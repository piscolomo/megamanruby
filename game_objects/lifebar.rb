class Lifebar < Chingu::GameObject
  
  def setup
    @lines = 30
    @y = 100
    @lines.times do
    	line = Linelifebar.create(:y => @y)
    	@y += line.height + 2
    end
  end
  
end