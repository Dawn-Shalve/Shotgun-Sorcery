extends CharacterBody2D
var items = [0,1]
var dir = 1
var SPEED = 200.0
var health = 100
const JUMP_VELOCITY = -400.0
var deflecting = false
var tick = true
var ticking = false
var idle = false
@onready var sprite = $AnimatedSprite2D
@onready var weapon = $Node2D/Sprite2D
var itemdict = {
	0:["None",0],
	1:["Speed",1,],
	2:["Health",40],
	3:["Damage",10],
	5:["None",0],
	6:["Health",5],
	7:["None",0],
	8:["Speed",1],
	
}
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	
	Global.itemtick.connect(itemtick)
	Global.player = self
	Global.loadingscreen.connect(loading)
	kashupdate()
	Global.kashupdate.connect(kashupdate)
	Global.healthupdate.connect(healthupdate)

func healthupdate():
	if Global.health > health:
		Global.health = health
	else:
		health = Global.health
	$PhantomCamera2D/Control/VBoxContainer/ProgressBar.max_value = Global.maxhealth
	

func kashupdate():
	$PhantomCamera2D/Control/RichTextLabel2.clear()
	$PhantomCamera2D/Control/RichTextLabel2.add_text(str(Global.money))
func loading():
	$PhantomCamera2D/Control/AnimatedSprite2D.visible = true
	for x in 100:
		Global.loadingconfirm.emit()

func retime():
	if ticking:
		pass
	else:
		print(tick)
		ticking = true
		await get_tree().create_timer(1).timeout
		tick = true
		ticking = false

func itemtick():
	for x in items.size():
		var type = itemdict[items[x]][0]
		if type == "None":
			continue
		if type == "Speed":
			SPEED = SPEED + itemdict[items[x]][1]
		if type == "Health":
			Global.maxhealth = Global.maxhealth + itemdict[items[x]][1]
		if type == "Damage":
			Global.damage = Global.damage + itemdict[items[x]][1]
	Global.healthupdate.emit()
	print(items)

func _process(delta):
	if tick == false:
		if ticking == true:
			pass
		else:
			print("retiming")
			retime()
func _physics_process(delta):
	if tick == false:
		if ticking == true:
			pass
		else:
			retime()
			Global.healthupdate.emit()
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
	if Global.cutscene == false:
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
	if event.is_action_pressed("deflect") and !deflecting:
		deflecting = true
		$Node2D/Sprite2D/Area2D/CollisionShape2D.disabled = false
		weapon.texture = load("res://assets/imagesandtiles/sword.png")
		await get_tree().create_timer(0.4).timeout
		weapon.texture = load("res://assets/imagesandtiles/shotgun.png")
		$Node2D/Sprite2D/Area2D/CollisionShape2D.disabled = true
		deflecting = false


func _on_area_2d_area_entered(area):
	if area.is_in_group("item") and area.available:
		items.append(area.id)
