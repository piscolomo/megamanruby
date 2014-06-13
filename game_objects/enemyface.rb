class EnemyFace < GameObject
	traits :bounding_box, :collision_detection
	attr_accessor :state, :power

	def setup
		@animations= Animation.new(:file => "enemyface.png", :size => [46,48], :delay => 400)
		@animations.frame_names = {:stand => 0..0, :walk => 0..3}
		@state = :stand
		@image = @animations[@state].next
		@zorder = 999999
		@power = 3
	end

	def update
		@image = @animations[@state].next
	end
end
