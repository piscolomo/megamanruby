class Lifeball < GameObject
  traits :bounding_circle, :collision_detection
  
  def setup
    @image = Image["lifeball.png"]
    @zorder = 9999999
    cache_bounding_circle
  end
end