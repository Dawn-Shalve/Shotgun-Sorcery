extends CharacterBody2D

signal followandkill
var player = null
var health = 10
var speed = 25
var enabled = true
var startprocessing = false
var swung = false
var plr = Vector2(0,0)
func _ready():
	followandkill.connect(follow)
	
func follow():
	$Area2D.monitoring = true
	print("following")
	startprocessing = true

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player and swung == false and enabled:
		plr = player.global_position
		look_at(plr)
		velocity = (plr - global_position).normalized() * speed
	if player and swung and enabled:
		plr = $sword/Node2D.global_position
		velocity = (plr - global_position).normalized() * speed * 5
		
		
	move_and_slide()

func _process(delta):
	if health == 0:
		if $"../Rack":
			$"../Rack".swordnotdead = false
		else:
			pass
		self.queue_free()
	if Vector2i(plr) == Vector2i(global_position):
		if $"../Rack":
			$"../Rack".swordnotdead = false
		else:
			pass
		Global.health = Global.health - 10
		self.queue_free()
		
	if player and !swung :
		await get_tree().create_timer(5).timeout
		if player:
			swung = true
	if player and swung:
		$Area2D/CollisionShape2D.shape.radius = 125
		await get_tree().create_timer(1).timeout
		if $"../Rack":
			$"../Rack".swordnotdead = false
		else:
			pass
		self.queue_free()
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player = body
	if body.is_in_group("deflect"):
		if $"../Rack":
			$"../Rack".swordnotdead = false
		else:
			pass
		self.queue_free()


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player = null
	if body.is_in_group("deflect"):
		if $"../Rack":
			$"../Rack".swordnotdead = false
		else:
			pass
		self.queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("deflect"):
		if $"../Rack":
			$"../Rack".swordnotdead = false
		else:
			pass
		self.queue_free()
