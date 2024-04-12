extends StaticBody2D
@onready var anim = $"../Sword/AnimationPlayer"
var followingplayer = false
var player
var exit = true
var swordnotdead = true
var health = 10
@onready var sword = $"../Sword"
@onready var sword2 = $"../Sword2"
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("inrack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_swordradius_body_entered(body):
	if body.is_in_group("player") and exit and swordnotdead:
		
		anim.play("exitrack")
		followingplayer = true
		await anim.animation_finished
		anim.play("idle")
		player = body
		exit = false
		followandkill()
	if body is TileMap:
		var map = body.local_to_map(body.position)
		var tiledata = body.get_cell_tile_data(0,map)
		if tiledata is TileData:
			if tiledata.get_custom_data("id") == 2 or tiledata.get_custom_data("id") == 1:
				var parent = get_parent()
				parent.queue_free()
		else:
			pass

func followandkill():
	sword.followandkill.emit()
	var big = randi_range(0,1)
	if big == 1:
		sword2.followandkill.emit()
	else:
		sword2.enabled = false
	


func _on_swordradius_area_entered(area):
	if area.is_in_group("bigrack"):
		position.y = area.position.y
	if area.is_in_group("bullet"):
		$racksprite.visible = false
		$CollisionShape2D.disabled = true
		$"../CPUParticles2D".visible = true
		await get_tree().create_timer(1).timeout
		$"../CPUParticles2D".visible = false
		self.queue_free()
