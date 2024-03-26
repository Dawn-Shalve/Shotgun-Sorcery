extends CharacterBody2D

var dir = 1
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var idle = false
@onready var sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	var direction = Input.get_vector("left","right","up","down")
	if direction:
		velocity = direction * SPEED
		idle = false
		checkanim()
	else:
		velocity = Vector2.ZERO
		idle = true
		checkanim()
	move_and_slide()


func checkanim():
	if idle:
		if dir == 1:
			sprite.play("leftidle")
		if dir == 2:
			sprite.play("rightidle")
		if dir == 3:
			sprite.play("upidle")
		if dir == 4:
			sprite.play("downidle")
	else:
		if dir == 1:
			sprite.play("leftwalk")
		if dir == 2:
			sprite.play("rightwalk")
		if dir == 3:
			sprite.play("upwalk")
		if dir == 4:
			sprite.play("downwalk")

func _input(event):
	if event.is_action_pressed("left"):
		dir = 1
		sprite.flip_h = true
	if event.is_action_pressed("right"):
		dir = 2
		sprite.flip_h = false
	if event.is_action_pressed("up"):
		dir = 3
		sprite.flip_h = false
	if event.is_action_pressed("down"):
		dir = 4
		sprite.flip_h = false
