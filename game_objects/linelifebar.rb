class Linelifebar < Chingu::GameObject
	attr_accessor :height

  def initialize(options={})
  	super
  	@y = options[:y]
  end

  def to_s; end
  
  def setup
  	@x = 50
  	@color = 0xffffffff
    @width = 20
    @height = 3
    @zorder = 999999
  end

  def draw
  	$window.fill_rect(Chingu::Rect.new(@x, @y, @width , @height), Gosu::Color.new(@color), @zorder)	
  end
end