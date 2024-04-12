extends Node
var muzzlepos = Vector2(0,0)
var bullettransform = Vector2(0,0)
var shots = 3
var menu = false
var isinshop = false
signal kashupdate
signal healthupdate
var money = 100
signal loadingscreen
signal loadingconfirm
var player = null
signal itemtick
signal shotgunreload
signal shotgunshot
var floor = 1
var cutscene = false
var maxhealth = 100
var damage = 10
var shopvisit = 0
var hospitalvisit = 0
var dealervisit = 0
var bossvisit = 0
var visitrand = []
var health = 100
signal shotgunbulletchange
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("end"):
		get_tree().quit()
