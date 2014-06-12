class Pause < GameState
  def initialize
    super
    self.input = {:p => :un_pause}
    @title = Text.create(:text=> "PAUSA, aprieta p nuevamente para seguir jugando", :x=> 100, :y=> 200, :size=> 25, :zorder => 9999999)
  end
  def un_pause; pop_game_state; end
  def draw
    super
    previous_game_state.draw
  end
end