extends StaticBody2D
#add in animation
func _ready():
	$PointLight2D.texture_scale = randf_range(3.34,4.35)
	position = position + Vector2(1,1)

func _on_area_2d_body_entered(body):
	self.queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("lights"):
		self.queue_free()
