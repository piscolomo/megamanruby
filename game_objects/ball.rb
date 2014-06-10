class Ball < Chingu::GameObject
  traits :bounding_circle, :collision_detection
  
  def setup
    @image = Image["bala.png"]
    @zorder = 9999999
    cache_bounding_circle
  end

  def initialize(options={})
  	super
  	@direction = options[:direction]
  end

  def update
    @direction == "right" ?  @x += 4 : @x -= 4
  end
end