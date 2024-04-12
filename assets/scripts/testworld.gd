extends Node2D
signal load

# Called when the node enters the scene tree for the first time.
func _ready():
	load.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
