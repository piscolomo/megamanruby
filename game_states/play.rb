class Play < Chingu::GameState
	trait :viewport
	def initialize
		super
    destroy_instances
		self.input = {:p => Pause, :e => :edit}
		self.viewport.lag = 0
		self.viewport.game_area = [0,0,5000,600]
		load_game_objects
		@parallax = Chingu::Parallax.new(:x => 0, :y=>0, :rotation_center => :top_left)
    @parallax << { :image => "background.jpg", :repeat_x => true, :repeat_y => true}
		@megaman = Megaman.create(:x => 80, :y=>200)
		@lifebar = Lifebar.create
	end

  #when a user decide to continue(from lose screen) chingu load for default instances of previous objects
  def destroy_instances
    #puts Megaman.all
    Megaman.destroy_all
    EnemyFace.destroy_all
  end

	def edit
    push_game_state(GameStates::Edit.new(:grid => [18,18], :classes => [EnemyFace, Floor]))
  end

  def draw
  	super
  	@lifebar.draw_position(self.viewport.x)
  	@parallax.draw
  end

	def update
		super
    push_game_state(Lose) if @lifebar.health == 0

		self.viewport.center_around(@megaman)
		@parallax.camera_x, @parallax.camera_y = self.viewport.x.to_i, self.viewport.y.to_i
		@parallax.update

		EnemyFace.all.each do |face|
    	if face.x < @megaman.x
    		face.x += 1 
    		face.direction = :right
    	else
    		face.x -= 1
    		face.direction = :left
    	end
    	face.y < @megaman.y - @megaman.height/2 ? face.y += 1 : face.y -= 1
    end

    Ball.each_collision(EnemyFace) do |ball, face|
	    face.destroy
	    ball.destroy
    end

    @megaman.each_collision(EnemyFace) do |me, face|
    	me.take_damage
      @lifebar.downlife(face.power)
    end
	end
end