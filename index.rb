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
	def initialize(options={})
		super
	end
end

Game.new.show