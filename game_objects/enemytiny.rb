class EnemyTiny < GameObject
	traits :bounding_box, :collision_detection, :velocity
	attr_accessor :direction, :power

	def setup
		@animations= Animation.new(:file => "enemytiny.png", :size => [22,21], :delay => 400)
		@animations.frame_names = { :stand=> 5..5, :walk => 0..5}
		@direction = :stand
		@factor_x = 1
		@image = @animations[@direction].next
		@zorder = 999999
		@power = 2
		self.max_velocity = 10
    self.acceleration_y = 0.5
	end

	def walk; 

	def update
		@image = @animations[@direction].next
		self.each_collision(Floor){ |enemytiny, floor| enemytiny.y = floor.bb.top - 10 }
	end
end
