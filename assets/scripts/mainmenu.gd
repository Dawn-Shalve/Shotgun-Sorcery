extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	Function.load_screen_to_scene("res://assets/scenes/worldproceedtest.tscn")


func _on_texture_button_2_pressed():
	pass # Replace with function body.


func _on_texture_button_3_pressed():
	get_tree().quit()
