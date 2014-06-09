require 'chingu'
include Gosu
include Chingu

require_rel 'game_states/*'
require_rel 'game_objects/*'

class Game < Chingu::Window
	def initialize
		super(800, 600)
		self.caption = "Megaman Game"
		self.input = {:escape => :exit}
		push_game_state(Intro)
	end
end

Game.new.show