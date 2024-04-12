extends Node2D
@onready var muzzle = $Sprite2D/muzzle
signal load
# Called when the node enters the scene tree for the first time.
func _ready():
	load.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	await load
	Global.muzzlepos = muzzle.global_position
	Global.bullettransform = muzzle.transform
	
func _input(event):
	load.emit()
	if event is InputEventMouseMotion:
		var mouse = get_global_mouse_position()
		look_at(mouse)
	if event.is_action_pressed("shoot") and Global.menu == false and Global.shots != 0:
		Global.shotgunshot.emit()
		var bullet = load("res://assets/scenes/shotgunbullet.tscn").instantiate()
		owner.owner.add_child(bullet)
		bullet.shot1.transform = muzzle.global_transform
		bullet.shot2.transform = muzzle.global_transform
		bullet.shot3.transform = muzzle.global_transform
