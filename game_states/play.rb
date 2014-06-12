class Play < GameState
	trait :viewport
	def initialize
		super
    destroy_instances
		self.input = {:p => Pause, :e => :edit}
		self.viewport.lag = 0
		self.viewport.game_area = [0,0,5000,600]
		load_game_objects
		@parallax = Parallax.new(:x => 0, :y=>0, :rotation_center => :top_left)
    @parallax << { :image => "background.jpg", :repeat_x => true, :repeat_y => true}
		@megaman = Megaman.create(:x => 80, :y => 200)
		@lifebar = Lifebar.create(:x => 30, :y => 100)
	end

  #when a user decide to continue(from lose screen) chingu load for default instances of previous objects
  def destroy_instances
    #puts Megaman.all
    Megaman.destroy_all
    EnemyFace.destroy_all
  end

	def edit
    push_game_state(GameStates::Edit.new(:grid => [18,18], :classes => [EnemyFace, EnemyTiny, Floor, Lifeball]))
  end

  def draw
  	super
  	@lifebar.draw_position(self.viewport.x)
  	@parallax.draw
  end

  #make the EnemyFace follow megaman
  def follow_megaman(options={:fly => false, :shoot => false})
    options[:classname].all.each do |enemy|
      enemy.shoot if options[:shoot] and self.viewport.inside?(enemy)
      unless (@megaman.x - enemy.x).abs > options[:distance]
        enemy.state = :walk
        (enemy.y < @megaman.y - @megaman.height/2 ? enemy.y += 1 : enemy.y -= 1) if options[:fly]
        if enemy.x < @megaman.x
          enemy.x += 1 
          enemy.factor_x = -1
        else
          enemy.x -= 1
          enemy.factor_x = 1
        end
      else
        enemy.state = :stand
      end
    end
  end

	def update
		super

    #lose the game if your life is 0
    push_game_state(Lose) if @lifebar.health == 0

    #lose the game if megaman jump to hollow
    push_game_state(Lose) if @megaman.y > $window.height

    #move the background
		self.viewport.center_around(@megaman)
		@parallax.camera_x, @parallax.camera_y = self.viewport.x.to_i, self.viewport.y.to_i
		@parallax.update

    #balls are destroyed if they are outside the view
    Ball.all.each {|ball| ball.destroy unless self.viewport.inside?(ball)}
    BallRed.all.each {|ball| ball.destroy unless self.viewport.inside?(ball)}

    #enemies moves
    follow_megaman :classname => EnemyFace, :distance => 600, :fly => true
    follow_megaman :classname => EnemyTiny, :distance => 300, :shoot => true

    #destroy EnemyFace and ball if collision  
    Ball.each_collision(EnemyFace, EnemyTiny) do |ball, enemy|
	    enemy.destroy
	    ball.destroy
    end

    #down life if megaman collision with EnemyFace
    @megaman.each_collision(EnemyFace, EnemyTiny) do |me, enemy|
    	me.take_damage
      @lifebar.downlife(enemy.power)
    end

    #up life if megaman take the lifeball
    @megaman.each_collision(Lifeball) do |me, lifeball|
      @lifebar.uplife
      lifeball.destroy
    end
	end
end