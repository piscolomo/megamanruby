require 'chingu'
include Gosu

class Game < Chingu::Window
	def initialize
		super(800, 600)
		self.caption = "Megaman Game"
		self.input = {:escape => :exit}
		@megaman = Megaman.create(:x => 80, :y=>300)
	end  
end

class Megaman < Chingu::GameObject
	def setup
		@animations = {}
		@state = :stand
		@direction = :right
		@last_x, @last_y = @x, @y
	end

	def initialize(options={})
		super
		self.input = [:holding_left, :holding_right]
		@animations[:stand] = Chingu::Animation.new(:file => "standfull.png", :size => [31,24], :delay => 500)
		@animations[:stand].frame_names = { :shootleft => 0, :left => 1..3, :right => 4..6, :shootright => 7}
		@animations[:run] = Chingu::Animation.new(:file => "runfull.png", :size => [24,24], :delay => 200)
		@animations[:run].frame_names = { :left => 0..3, :right => 4..7}
	end

	def update
		@image = @animations[@state][@direction].next!
		@state = :stand if @x == @last_x
		@last_x, @last_y = @x, @y
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
end

Game.new.show