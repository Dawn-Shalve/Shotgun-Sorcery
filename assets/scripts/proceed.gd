extends Node2D


@export var level_size := Vector2(100, 80)
@export var rooms_size := Vector2(10, 15)
@export var rooms_max := 22
var doorspawned = false
signal load
@onready var spawns = $spawns
@onready var level: TileMap = $Level
@onready var camera: Camera2D = $Camera2D
var Tilesetneighbor = {
	0:TileSet.CELL_NEIGHBOR_RIGHT_SIDE,
	1:TileSet.CELL_NEIGHBOR_TOP_SIDE,
	2:TileSet.CELL_NEIGHBOR_LEFT_SIDE,
	3:TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,
}

func _ready() -> void:
	_setup_camera()
	_generate()
	load.emit()


func _setup_camera() -> void:
	camera.position = level.map_to_local(level_size / 2)
	var z := 64 / maxf(level_size.x, level_size.y)
	camera.zoom = Vector2(z, z)
	

func _generate() -> void:
	level.clear()
	for x in 100:
		level.set_cell(0, Vector2(x,0), 0, Vector2i(7,3), 0)
		for y in 100:
			level.set_cell(0, Vector2(x,y), 0, Vector2i(7,3), 0)
	for vector in _generate_data():
		level.set_cell(0, vector, 0, Vector2i.ZERO, 0)
		$CharacterBody2D.global_position = vector * 16
		
	for x in 100:
		for y in 100:
			var thingy = Vector2i(x,y)
			if doorspawned == false:
				gendoor(thingy)
			var tiledata := level.get_cell_tile_data(0,thingy)
			if !tiledata is TileData:
				continue
			var customdata = tiledata.get_custom_data("id")
			if customdata == 1:
				checksides(thingy)


func gendoor(thingy):
	var door = load("res://assets/scenes/door.tscn").instantiate()
	var usedrect = $Level.get_used_rect()
	door.position = thingy * 16
	var levelpos = level.local_to_map(door.position)
	var tiledata = level.get_cell_tile_data(0,levelpos)
	if tiledata is TileData:
		var sides = getneighbor(levelpos)
		var rightneighbors = level.get_neighbor_cell(levelpos,Tilesetneighbor[0])
		var rightsides = getneighbor(rightneighbors)
		var leftneighbors = level.get_neighbor_cell(levelpos,Tilesetneighbor[2])
		var leftsides = getneighbor(leftneighbors)
		if sides[2] == 3 and sides [0] == 3 and sides[1] == 3 and sides[3] == 3:
			spawns.add_child(door)
			doorspawned = true
			print("found spot!")
		else:
			print("regen : (")


func getneighbor(tile):
	var sides = [0,0,0,0]
	for x in 4:
		var tile2 = level.get_neighbor_cell(tile,Tilesetneighbor[x])
		var data := level.get_cell_tile_data(0,tile2)
		if not data:
			continue
		var cus = data.get_custom_data("id")
		sides.insert(x,cus)
		sides.resize(4)
	return sides

func checksides(thingy):
	var wallside = false
	var wallright = false
	var sides = [0,0,0,0]
	for x in 4:
		var tile = level.get_neighbor_cell(thingy,Tilesetneighbor[x])
		var tiledata := level.get_cell_tile_data(0,tile)
		if not tiledata:
			continue
		var customdata = tiledata.get_custom_data("id")
		sides.insert(x,customdata)
		sides.resize(4)
	#if right is blank and left is blank and up is blank and right is blank then blank
	if sides[0] == 1 and sides[2] == 1 and sides[1] == 1 and sides[3] == 1:
		level.set_cell(0,thingy,0,Vector2i(7,3),0)
	#if right is blank and bottom is a floor or right is a wall and bottom is blank then full wall
	if sides[0] == 1 and sides[3] == 3 or sides[0] == 2 and sides[3] == 3:
		level.set_cell(0,thingy,0,Vector2i(5,3),0)
	#if right is a floor and left is a wall then right corner
	if sides[0] == 3 and sides[2] == 2:
		level.set_cell(0,thingy,0,Vector2i(6,3),0)
	#if right is wall and left is floor then left corner
	if sides[0] == 2 and sides[2] == 3:
		level.set_cell(0,thingy,0,Vector2i(6,4),0)
	#if right is floor and left is floor and bottom is floor then floor
	if sides[0] == 3 and sides[2] == 3 and sides[3] == 3:
		level.set_cell(0,thingy,0,Vector2i(0,0),0)
	#if bottom is wall and left is blank and right is floor the left wall
	if sides[3] == 2 and sides[2] == 1 and sides[0] == 3:
		level.set_cell(0,thingy,0,Vector2i(5,4),0)
		#if bottom is wall and left is floor then left corner
	if sides[3] == 2 and sides[2] == 3:
		level.set_cell(0,thingy,0,Vector2i(5,4),0)
		#if right is floor and left is floor then floor
	if sides[0] == 3 and sides[2] == 3:
		level.set_cell(0,thingy,0,Vector2i(0,0),0)
	if sides[1] == 3 and sides[3] == 3:
		level.set_cell(0,thingy,0,Vector2i(0,0),0)
	if sides[1] == 3 and sides[0] == 3:
		level.set_cell(0,thingy,0,Vector2i(0,0),0)
		
func _generate_data() -> Array:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var rooms := []
	var data := {}
	
	for r in range(rooms_max):
		var room := _get_random_room(rng)
		for x in 100:
			var potatolight = load("res://assets/scenes/litnt.tscn").instantiate()
			potatolight.position = Vector2(randi_range(room.position.x, room.end.x), randi_range(room.position.y,room.end.y)) * 16
			spawns.add_child(potatolight)
		for x in 16:
			var swords = randi_range(0,1)
			if swords == 1:
				var sword = load("res://enemies/sword.tscn").instantiate()
				sword.position = Vector2(randi_range(room.position.x, room.end.x), randi_range(room.position.y,room.end.y)) * 16
				spawns.add_child(sword)
		for x in 12:
			var swords = randi_range(0,1)
			if swords == 1:
				var sword = load("res://assets/scenes/guard.tscn").instantiate()
				sword.position = Vector2(randi_range(room.position.x, room.end.x), randi_range(room.position.y,room.end.y)) * 16
				spawns.add_child(sword)
		if _intersects(rooms, room):
			continue

		_add_room(data, rooms, room)
		if rooms.size() > 1:
			var room_previous: Rect2 = rooms[-2]
			_add_connection(rng, data, room_previous, room)
	return data.keys()
	
	


func _get_random_room(rng: RandomNumberGenerator) -> Rect2:
	var width := rng.randi_range(rooms_size.x, rooms_size.y)
	var height := rng.randi_range(rooms_size.x, rooms_size.y)
	var x := rng.randi_range(0, level_size.x - width - 1)
	var y := rng.randi_range(0, level_size.y - height - 1)
	return Rect2(x, y, width, height)


func _add_room(data: Dictionary, rooms: Array, room: Rect2) -> void:
	rooms.push_back(room)
	for x in range(room.position.x, room.end.x):
		for y in range(room.position.y, room.end.y):
			data[Vector2(x, y)] = null


func _add_connection(
	rng: RandomNumberGenerator, data: Dictionary, room1: Rect2, room2: Rect2
) -> void:
	var room_center1 := (room1.position + room1.end) / 2
	var room_center12 = (room1.position + Vector2(1,1) + room1.end + Vector2(1,1)) / 2
	var room_center13 = (room1.position + Vector2(-1,-1) + room1.end + Vector2(-1,-1)) / 2
	var room_center2 := (room2.position + room2.end) / 2
	var room_center22 = (room2.position + Vector2(1,1) + room2.end + Vector2(1,1)) / 2
	var room_center23 = (room2.position + Vector2(-1,-1) + room2.end + Vector2(-1,-1)) / 2
	if rng.randi_range(0, 1) == 0:
		_add_corridor(data, room_center1.x, room_center2.x, room_center1.y, Vector2.AXIS_X)
		_add_corridor(data, room_center1.y, room_center2.y, room_center2.x, Vector2.AXIS_Y)
		_add_corridor(data, room_center12.x, room_center22.x, room_center12.y, Vector2.AXIS_X)
		_add_corridor(data, room_center12.y, room_center22.y, room_center22.x, Vector2.AXIS_Y)
		_add_corridor(data, room_center13.x, room_center23.x, room_center13.y, Vector2.AXIS_X)
		_add_corridor(data, room_center13.y, room_center23.y, room_center23.x, Vector2.AXIS_Y)
		var potatolight = load("res://assets/scenes/litnt.tscn").instantiate()
		potatolight.position = Vector2(randi_range(room_center1.x, room_center2.x), randi_range(room_center1.y,room_center2.y)) * 16
		spawns.add_child(potatolight)
	else:
		_add_corridor(data, room_center1.y, room_center2.y, room_center1.x, Vector2.AXIS_Y)
		_add_corridor(data, room_center1.x, room_center2.x, room_center2.y, Vector2.AXIS_X)
		_add_corridor(data, room_center12.y, room_center22.y, room_center12.x, Vector2.AXIS_Y)
		_add_corridor(data, room_center12.x, room_center22.x, room_center22.y, Vector2.AXIS_X)
		_add_corridor(data, room_center13.y, room_center23.y, room_center13.x, Vector2.AXIS_Y)
		_add_corridor(data, room_center13.x, room_center23.x, room_center23.y, Vector2.AXIS_X)
		var potatolight = load("res://assets/scenes/litnt.tscn").instantiate()
		potatolight.position = Vector2(randi_range(room_center1.y, room_center2.y), randi_range(room_center1.x,room_center2.x)) * 16
		spawns.add_child(potatolight)
	var potatolight = load("res://assets/scenes/litnt.tscn").instantiate()
	potatolight.position = Vector2(randi_range(room_center1.y, room_center2.y), randi_range(room_center1.x,room_center2.x)) * 16
	spawns.add_child(potatolight)


func _add_corridor(data: Dictionary, start: int, end: int, constant: int, axis: int) -> void:
	for t in range(min(start, end), max(start, end) + 1):
		var point := Vector2.ZERO
		match axis:
			Vector2.AXIS_X: point = Vector2(t, constant)
			Vector2.AXIS_Y: point = Vector2(constant, t)
		data[point] = null


func _intersects(rooms: Array, room: Rect2) -> bool:
	var out := false
	for room_other in rooms:
		if room.intersects(room_other):
			out = true
			break
	return out
