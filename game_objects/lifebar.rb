class Lifebar < GameObject
  attr_accessor :health, :hitting
  trait :timer
  
  def setup
    @max_health = 10
    @health = 9
    @x = 30
    @y = 100
    @lines = []
    @hitting = false
    @health.times do
    	line = Linelifebar.create(:x => @x, :y => @y)
    	@y += line.height + 2
    	@lines << line
    end
  end

  def refresh_life
    @health = @lines.size
  end

  def draw_position(posx)
    @posx = posx
  end

  def draw
    unless @lines.empty?
      @lines.each { |line| line.x = @posx.to_i + @x }
    end
  end

  def downlife(damage)
  	unless @hitting
    	@hitting = true
      	damage.times do
          unless @lines.empty?
        		lineout = @lines.shift
        		lineout.destroy
            refresh_life
        	end
        end
    	after(3000){ @hitting = false }
    end
  end

  def uplife
    posy = @lines.first.y
    5.times do
      if @health < @max_health
        line = Linelifebar.create(:x => @x, :y => posy )
        posy -= line.height + 2
        @lines.unshift line
        refresh_life
      end
    end
  end

end