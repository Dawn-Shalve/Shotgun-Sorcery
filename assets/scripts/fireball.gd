extends CharacterBody2D
var player = null
var detonated = false
var speed = 100
var shot = true
var recount = false
# Called when the node enters the scene tree for the first time.
func _ready():
	player = Global.player
	timeshot()
	await get_tree().create_timer(5.0).timeout
	detonate()

func timeshot():
	await get_tree().create_timer(0.1).timeout
	shot = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if player and detonated == false and shot:
		velocity = position.direction_to(player.position) * speed
		if recount:
			look_at(player.position)
			player = $point
			recount = true
	if detonated:
		velocity = Vector2.ZERO
	move_and_slide()

func detonate():
	if detonated == false:
		print("detonated")
		$AnimatedSprite2D.visible = false
		$fireradius.visible = true
		detonated = true
		$CollisionShape2D.disabled = true
		
		await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_detonationrange_body_entered(body):
	if body.is_in_group("player"):
		player = body
	if detonated == true:
		if body.is_in_group("player") or body.is_in_group("livingbeing"):
			if body.tick == true:
				print(body.health)
				body.health = body.health - 10






func _on_area_2d_body_entered(body):
	if body.is_in_group("bullet") or body.is_in_group("deflect"):
		speed = -speed
	if body.is_in_group("player"):
		detonate()
	if body.is_in_group("player") or body.is_in_group("livingbeing"):
		if body.tick == true:
			print(body.health)
			body.tick = false
			body.health = body.health - 10
	
