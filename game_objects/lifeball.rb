class Lifeball < GameObject
  traits :bounding_circle, :collision_detection, :velocity
  
  def setup
    @image = Image["lifeball.png"]
    @zorder = 9999999
    self.max_velocity = 10
    self.acceleration_y = 0.5
    cache_bounding_circle
  end

  def update
  	#lifeball is on the floor
  	self.each_collision(Floor){ |lifeball, floor| lifeball.y = floor.bb.top - 8 }
  end
end