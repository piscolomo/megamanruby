class Ball < Chingu::GameObject
  traits :bounding_circle, :collision_detection
  
  def setup
    @image = Image["bala.png"]
    cache_bounding_circle
  end

  def initialize(options={})
  	super
  	@direction = options[:direction]
  end

  def update
    if @direction == "right" 
    	@x += 4
    else
    	@x -= 4
    end
  end
end