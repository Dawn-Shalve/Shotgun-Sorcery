extends RigidBody2D
var size = 1


func _ready():
	size = randi_range(8,16)
	make_room(Vector2(0,0),size)

func make_room(_pos,_size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 0.75
	s.extents = _size
	$CollisionShape2D.shape = s
