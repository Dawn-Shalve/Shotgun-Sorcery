extends Area2D

var speed = 2500


func _ready():
	self.scale = Vector2(0.1,0.1)

func _physics_process(delta):
	var muzzleposx = Global.muzzlepos.x
	self.scale = Vector2(0.1,0.1)
	position += transform.x * speed * delta * Vector2(randi_range(0,3),randi_range(0,3))

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.health = body.health - Global.damage
		self.queue_free()
	queue_free()
