require 'chingu'
include Gosu

class Game < Chingu::Window
	def initialize
		super(800, 600)
		self.caption = "Megaman Game"
		self.input = {:escape => :exit}
		push_game_state(Intro)
	end
end

class Intro < Chingu::GameState
	def initialize
		super
		self.input = {:return => Play}
	end
	def draw
		super
		Image["intro2.png"].draw(0, 0, 0)
	end
end

class Play < Chingu::GameState
	def initialize
		super
		self.input = {:p => Pause}
		@megaman = Megaman.create(:x => 80, :y=>300)
		@floor = Floor.create(:x => 0, :y => 550)
	end
end

class Pause < Chingu::GameState
  def initialize
    super
    self.input = {:p => :un_pause}
    @title = Chingu::Text.create(:text=> "PAUSA, aprieta p nuevamente para seguir jugando", :x=> 100, :y=> 200, :size=> 20)
  end
  def un_pause; pop_game_state; end
  def draw
    super
    previous_game_state.draw
  end
end

class Floor < Chingu::GameObject
  traits :bounding_box, :collision_detection
  
  def setup
    @image = Image["burried.png"]
    self.width = 8000
    self.height = 40
    self.rotation_center = :bottom_left
    cache_bounding_box
  end
end

class Ball < Chingu::GameObject
  traits :bounding_circle, :collision_detection
  
  def setup
    @image = Image["bala.png"]
    cache_bounding_circle
  end

  def initialize(options={})
  	super
  	@direction = options[:direction]
  end

  def update
    if @direction == "right" 
    	@x += 4
    else
    	@x -= 4
    end
  end
end

class Megaman < Chingu::GameObject
	traits :bounding_box, :collision_detection, :velocity, :timer
	attr_accessor :jumping, :shooting

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
		self.input = [:holding_left, :holding_right, :holding_up, :left_control]

		@animations[:stand] = Chingu::Animation.new(:file => "standfull.png", :size => [31,24], :delay => 500)
		@animations[:stand].frame_names = { :left => 0..1, :right => 2..3}
		@animations[:run] = Chingu::Animation.new(:file => "runfull.png", :size => [24,24], :delay => 200)
		@animations[:run].frame_names = { :left => 0..3, :right => 4..7}
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
		@jumping = true
		self.velocity_y = -10
	end

	def left_control
		return if @shooting
		Ball.create(:x => @x, :y => @y-self.height/2, :direction => @direction.to_s)
		@shooting = true
		after(120){ @shooting = false }
	end

	def update
		@state = :stand if @x == @last_x

		if @jumping
			@image = @shooting ? Image["jump_shoot#{@direction}.png"] : Image["jump#{@direction}.png"]
		else
			@image = @shooting ? Image["shoot#{@direction}.png"] : @animations[@state][@direction].next!
		end
	
		@last_x, @last_y = @x, @y

		self.each_collision(Floor) do |me, floor|
      if me.velocity_y < 0  # down to hit the ceiling
        me.y = floor.bb.bottom + me.image.height * me.factor_y
        me.velocity_y = 0
      else  # Land on ground
        @jumping = false        
        me.y = floor.bb.top
      end
    end
	end
end

Game.new.show