extends CharacterBody2D
var target = null
var speed = 40
var initiate = false
var fighttarget = null
@onready var nav_agent = $NavigationAgent2D
func _physics_process(delta):
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	var intendeddir = dir * speed
	intendeddir = intendeddir + Vector2(randi_range(0,3),randi_range(0,3))
	velocity = intendeddir
	move_and_slide()


func _on_timer_timeout():
	make_path()
	
func _ready():
	await get_parent().get_parent().load
	initiate = true
func make_path():
	if target == null:
		pass
	else:
		nav_agent.target_position = target.global_position


func _on_area_2d_body_entered(body):
	if body.is_in_group("guard") or body.is_in_group("player") or body.is_in_group("prison"):
		target = body


func _on_area_2d_2_area_entered(area):
	pass # Replace with function body.


func _on_area_2d_2_body_entered(body):
	if body is TileMap and initiate == false:
		var map = body.local_to_map(body.position)
		var tiledata = body.get_cell_tile_data(0,map)
		if tiledata is TileData:
			if tiledata.get_custom_data("id") == 2 or tiledata.get_custom_data("id") == 1:
				queue_free()
		else:
			pass


func _on_area_2d_body_exited(body):
	if body.is_in_group("guard") or body.is_in_group("player") or body.is_in_group("prison"):
		target = null


func _on_fightradius_body_entered(body):
	pass # Replace with function body.
