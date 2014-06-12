class EnemyTiny < GameObject
	traits :bounding_box, :collision_detection, :velocity, :timer
	attr_accessor :state, :power

	def setup
		@animations= Animation.new(:file => "enemytiny.png", :size => [22,21], :delay => 400)
		@animations.frame_names = { :stand=> 5..5, :walk => 0..5}
		@state = :stand
		@factor_x = 1
		@image = @animations[@state].next
		@zorder = 999999
		@power = 2
		@shooting = false
		self.max_velocity = 10
    self.acceleration_y = 0.5
	end

	def direction; @factor_x > 0 ? :left : :right; end

	def shoot
		unless @shooting
			BallRed.create(:x => @x, :y => @y-self.height/2, :direction => direction)
			@shooting = true
			after(1500){ @shooting = false }
		end
	end

	def update
		@image = @animations[@state].next
		self.each_collision(Floor){ |enemytiny, floor| enemytiny.y = floor.bb.top - 10 }
	end
end
