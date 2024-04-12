extends Node2D
signal load

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.isinshop = true
	load.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
