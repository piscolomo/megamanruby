class Lifebar < Chingu::GameObject
  attr_accessor :health, :hitting
  trait :timer
  
  def setup
    @health = 30
    @x = 30
    @y = 100
    @lines = []
    @hitting = false
    for i in (0..@health-1) do
    	line = Linelifebar.create(:x => @x, :y => @y)
    	@y += line.height + 2
    	@lines << line
    end
  end

  def draw_position(posx)
    @posx = posx
  end

  def draw
    if @lines.size > 0
      @lines.each { |line|
        line.x = @posx.to_i + @x
      }
    end
  end

  def downlife(damage)
  	return if @hitting
  	@hitting = true
  	for i in (0..damage-1) do
  		lineout = @lines.shift
  		lineout.destroy
  		@health = @lines.size
  	end
  	after(3000){ @hitting = false }
  end

end