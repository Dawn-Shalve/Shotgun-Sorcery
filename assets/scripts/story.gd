extends Node2D
@onready var sprite = $AnimatedSprite2D
signal finished
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	sprite.play("default")
	speak("In times before modern magic, magic was unregulated.")
	await finished
	await get_tree().create_timer(5).timeout
	sprite.play("2")
	speak("Then, the regulatory magic administration stepped in.")
	await finished
	await get_tree().create_timer(5).timeout
	sprite.play("3")
	speak("They outlawed all non elemental magic, stifiling creativity and innovation.")
	await finished
	await get_tree().create_timer(5).timeout
	$AudioStreamPlayer.stop()
	sprite.play("4")
	speak("But I think there should be a change.")
	await finished
	await get_tree().create_timer(3).timeout
	$ColorRect2.visible = true
	await get_tree().create_timer(5).timeout
	Function.load_screen_to_scene("res://assets/scenes/mainmenu.tscn",{"test":"test"})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("interact"):
		Function.load_screen_to_scene("res://assets/scenes/mainmenu.tscn",{"test":"test"})

func speak(say):
	$RichTextLabel.clear()
	for x in say:
		$RichTextLabel.add_text(x)
		await get_tree().create_timer(0.05).timeout
		
	finished.emit()


