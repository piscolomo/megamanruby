class Floor < Chingu::GameObject
  traits :bounding_box, :collision_detection
  
  def setup
    @image = Image["floor1.png"]
    self.width = 800
    self.height = 104
    self.rotation_center = :bottom_left
    cache_bounding_box
  end
end