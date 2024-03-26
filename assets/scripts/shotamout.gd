extends Control
@onready var audio = $"../../AudioStreamPlayer2D"
@onready var shot1 = $HBoxContainer/TextureRect
@onready var shot2 = $HBoxContainer/TextureRect2
@onready var shot3 = $HBoxContainer/TextureRect3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.shots == 3:
		pass

func _input(event):
	if event.is_action_pressed("shoot") and Global.shots != 0:
		Global.shots = Global.shots - 1
		print(Global.shots)
		if Global.shots == 0:
			reload()


func reload():
	audio.stream = load("res://assets/soundfx/shotgun.mp3")
	audio.play()
	await get_tree().create_timer(2).timeout
	Global.shots = 3
