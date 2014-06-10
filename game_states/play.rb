class Play < Chingu::GameState
	trait :viewport
	def initialize
		super
		self.input = {:p => Pause, :e => :edit}
		self.viewport.lag = 0
		self.viewport.game_area = [0,0,5000,600]
		load_game_objects
		@parallax = Chingu::Parallax.create(:x => 0, :y=>0, :rotation_center => :top_left)
    @parallax.add_layer(:image => "background.jpg")
		@megaman = Megaman.create(:x => 80, :y=>500)
		@lifebar = Lifebar.create()
	end

	def edit
    push_game_state(GameStates::Edit.new(:grid => [18,18], :classes => [EnemyFace, Floor]))
  end

  def draw
  	super
  	@lifebar.draw_position(self.viewport.x)
  end

	def update
		super

		self.viewport.center_around(@megaman)

		unless @megaman.state == :stand
			@megaman.direction == :left ? @parallax.camera_x -= 0.5 : @parallax.camera_x += 0.5
		end

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

    Ball.each_collision(EnemyFace){ |ball, face|
	    face.destroy
	    ball.destroy
    }

    @megaman.each_collision(EnemyFace){ |me, face|
    	@lifebar.downlife(face.power)
    }
	end
end