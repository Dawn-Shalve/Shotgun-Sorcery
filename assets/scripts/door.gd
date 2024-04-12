extends StaticBody2D
var canint = false
var nextscene = null
# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	if parent.get_name() == "Spawns" or parent.get_name() == "spawns":
		parent = get_parent().get_parent()
	await parent.load
	if Global.isinshop:
		nextscene = "res://assets/scenes/worldproceedtest.tscn"
	else:
		nextscene = "res://assets/scenes/shop.tscn"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("interact") and canint:
		if nextscene == null:
			get_tree().quit()
		Dialogic.end_timeline()
		if Global.isinshop:
			Global.isinshop = false
		Function.load_screen_to_scene(nextscene,{"test":"test"})

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$Button.visible = true
		canint = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		$Button.visible = false
		canint = false
