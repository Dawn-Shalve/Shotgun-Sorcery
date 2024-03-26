extends Node
var muzzlepos = Vector2(0,0)
var bullettransform = Vector2(0,0)
var shots = 3
var menu = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("end"):
		get_tree().quit()
