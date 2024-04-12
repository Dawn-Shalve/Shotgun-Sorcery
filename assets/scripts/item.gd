extends Area2D
var id = 0
var available = false
var price = 0
var canbuy = false
var iteminfodict = {
	1:{"Sprite":load("res://assets/stick.png")},
	2:{"Sprite":load("res://assets/greenbean.png")},
	
	5:{"Sprite":load("res://assets/molotov.png"),"price":10,},
	6:{"Sprite":load("res://assets/tounge.png"),"price":5,},
	7:{"Sprite":load("res://assets/lighter.png"),"price":10,},
	8:{"Sprite":load("res://assets/bottleofgreendrugs.png"),"price":10,}
}
# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent().get_parent()
	await parent.load
	if Global.isinshop:
		id = randi_range(5,8)
	$Sprite2D.texture = iteminfodict[id]["Sprite"]
	price = iteminfodict[id]["price"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _input(event):
	if event.is_action_pressed("interact"):
		if canbuy:
			if price <= Global.money:
				Global.money = Global.money - price
				Global.kashupdate.emit()
				Global.player.items.append(id)
				Global.itemtick.emit()
				self.queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$Button.visible = true
		canbuy = true




func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		$Button.visible = false
		canbuy = false
