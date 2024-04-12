extends StaticBody2D
var layout = Dialogic.start(load("res://assets/dialogic/testtimeline.dtl"))

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.start(load("res://assets/dialogic/testtimeline.dtl"))
	var layout = Dialogic.start(load("res://assets/dialogic/testtimeline.dtl"))
	layout.register_character(load("res://assets/dialogic/Uncleterry.dch"),self)
# Called every frame. 'delta' is the elapsed time since the previous frame.



func _input(event):
	if event.is_action_pressed("ui_select"):
		pass
func _process(delta):
	pass
