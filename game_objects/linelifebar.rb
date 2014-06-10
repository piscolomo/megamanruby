class Linelifebar < Chingu::GameObject
	attr_accessor :height, :x

  def to_s; end
  
  def setup
  	@color = 0xffffffff
    @width = 20
    @height = 3
    @zorder = 999999
  end

  def draw
  	$window.fill_rect(Chingu::Rect.new(@x, @y, @width , @height), Gosu::Color.new(@color), @zorder)	
  end
end