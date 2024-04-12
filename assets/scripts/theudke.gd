extends CharacterBody2D
@onready var nav_agent = $NavigationAgent2D
var layout = Dialogic.start(load("res://assets/dialogic/theduke.dtl"))
var canmove = false
var target = null
var speed = 25
var bosscut = false

func _ready():
	pass




func _move():
	if target == null:
		pass
	else:
		nav_agent.target_position = target.global_position


func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and bosscut == false:
		bosscutscene()
		
		
func bosscutscene():
	if bosscut == false:
		bosscut = true
		Global.cutscene = true
		Dialogic.start(load("res://assets/dialogic/theduke.dtl"))
		var layout = Dialogic.start(load("res://assets/dialogic/theduke.dtl"))
		layout.register_character(load("res://assets/dialogic/theduke.dch"),self)
		for x in 10:
			position.y = position.y + 1
			await get_tree().create_timer(0.1).timeout
