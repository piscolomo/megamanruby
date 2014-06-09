class Intro < Chingu::GameState
	def initialize
		super
		self.input = {:return => Play}
	end
	def draw
		super
		Image["intro.jpg"].draw(0, 0, 0)
	end
end