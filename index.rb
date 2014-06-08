require 'chingu'
include Gosu

class Game < Chingu::Window
	def initialize
		super(800, 600)
		self.caption = "Megaman Game"
		self.input = {:escape => :exit}
		@megaman = Megaman.create(:x => 80, :y=>300)
		@floor = Floor.create(:x => 0, :y => 550)
	end  
end

class Floor < Chingu::GameObject
  traits :bounding_box, :collision_detection
  
  def setup
    @image = Image["burried.png"]
    @color = Color.new(0xff808080)
    self.width = 8000
    self.height = 40
    self.rotation_center = :bottom_left
    cache_bounding_box
  end
end

class Megaman < Chingu::GameObject
	traits :bounding_box, :collision_detection,  :velocity
	attr_accessor :jumping

	def setup
		@animations = {}
		@state = :stand
		@direction = :right
		@jumping = false
		self.max_velocity = 10
		self.acceleration_y = 0.5
		self.rotation_center = :bottom_center
		@last_x, @last_y = @x, @y
	end

	def initialize(options={})
		super
		self.input = [:holding_left, :holding_right, :holding_up]
		@animations[:stand] = Chingu::Animation.new(:file => "standfull.png", :size => [31,24], :delay => 500)
		@animations[:stand].frame_names = { :shootleft => 0, :left => 1..3, :right => 4..6, :shootright => 7}
		@animations[:run] = Chingu::Animation.new(:file => "runfull.png", :size => [24,24], :delay => 200)
		@animations[:run].frame_names = { :left => 0..3, :right => 4..7}
		@animations[:jump] = Chingu::Animation.new(:file => "jumpfull.png", :size => [35,31])
		@animations[:jump].frame_names = {:left => 0, :shootleft=> 1, :right => 2, :shootright => 3}
	end

	def holding_left
		@x -= 2
		@state = :run
		@direction = :left
	end

	def holding_right
	  @x += 2
	  @state = :run
	  @direction = :right
	end

	def holding_up
		return if @jumping
		@state = :jump
		@jumping = true
		self.velocity_y = -10
	end

	def update
		@state = :stand if @x == @last_x
		puts @jumping
		if @jumping
			#@image = @animations[@state][@direction]
		else
			@image = @animations[@state][@direction].next!
		end

		@last_x, @last_y = @x, @y

		self.each_collision(Floor) do |me, stone_wall|
      if self.velocity_y < 0  # hit the ceiling
        me.y = stone_wall.bb.bottom + me.image.height * self.factor_y
        self.velocity_y = 0
      else  # Land on ground
        @jumping = false        
        me.y = stone_wall.bb.top-1
      end
    end
	end
end

Game.new.show