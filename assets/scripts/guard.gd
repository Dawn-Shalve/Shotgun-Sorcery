extends CharacterBody2D
var speed  = 25
var isfireballing = false
var isfireballinganiming = false
var tick = true
var initiate = false
var keepmoving = true
var target = null
var health = 50
var player = null
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var sprite = $AnimatedSprite2D
var ticking = false
func _physics_process(delta: float):
	if isfireballing == false:
		fireballfunc()
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	var intendeddir = dir * speed
	velocity = dir * speed
	if tick == false:
		retime()
	if isfireballinganiming or keepmoving == false:
		velocity == Vector2.ZERO
	if velocity == Vector2.ZERO and isfireballinganiming == false:
		sprite.play("idle")
	else:
		sprite.play("default")
	move_and_slide()

func _ready():
	var modulate = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
	sprite.modulate = modulate + Color.from_hsv(0,0,0.5)
	await get_tree().create_timer(0.1).timeout
	initiate = true


func retime():
	if ticking:
		pass
	else:
		ticking = true
		await get_tree().create_timer(1).timeout
		tick = false
		ticking = false

func fireballfunc():
	if player:

		isfireballing = true
		await get_tree().create_timer(3).timeout
		var actualfireball = load("res://assets/scenes/fireball.tscn").instantiate()
		sprite.play("fireball")
		isfireballinganiming = true
		actualfireball.position = self.position
		var parent = get_parent()
		parent.add_child(actualfireball)
		print("shotfireball")
		isfireballing = false
		await sprite.animation_finished
		isfireballinganiming = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("bullet") or body.is_in_group("deflect"):
		print(health)
		health = health - Global.damage
		print("bullet")
	if body.is_in_group("player") or body.is_in_group("prison"):
		target = body
	if body is TileMap and initiate == false:
		var map = body.local_to_map(body.position)
		var tiledata = body.get_cell_tile_data(0,map)
		if tiledata is TileData:
			if tiledata.get_custom_data("id") == 2 or tiledata.get_custom_data("id") == 1:
				queue_free()
		else:
			pass

func _process(delta):
	if health <= 0:
		self.queue_free()

func _on_area_2d_body_exited(body):
	if body == target:
		target = null


func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet") or area.is_in_group("deflect"):
		print(health)
		health = health - Global.damage
		print("bullet")


func _on_timer_timeout():
	makepath()


func makepath() -> void:
	if target == null or keepmoving == false:
		pass
	else:
		nav_agent.target_position = target.global_position
		


func _on_area_2d_2_body_entered(body):
	if body is TileMap and initiate == false:
		var map = body.local_to_map(body.position)
		var tiledata = body.get_cell_tile_data(0,map)
		if tiledata is TileData:
			if tiledata.get_custom_data("id") == 2 or tiledata.get_custom_data("id") == 1:
				queue_free()
		else:
			pass
