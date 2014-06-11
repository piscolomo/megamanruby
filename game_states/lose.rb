class Lose < Chingu::GameState
  def initialize
    super
    self.input = {:return => :continue}
    @title = Chingu::Text.create(:text=> "GAME OVER, aprieta Enter para continuar", :x=> 100, :y=> 200, :size=> 25, :zorder => 9999999)
  end
  def continue
    push_game_state(Play)
  end
end