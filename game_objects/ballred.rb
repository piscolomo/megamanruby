class BallRed < GameObject
  traits :bounding_circle, :collision_detection
  attr_accessor :power
  
  def setup
    @image = Image["enemyball.png"]
    @zorder = 9999999
    @power = 2
    cache_bounding_circle
  end

  def initialize(options={})
  	super
  	@direction = options[:direction]
  end

  def update
    @direction == :right ?  @x += 6 : @x -= 6
  end
end