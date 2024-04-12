extends HBoxContainer
@onready var shoo = {
	0:$TextureRect,
	1:$TextureRect2,
	2:$TextureRect3,
}
var deathlines = {
	0:"                 You failed
------------------------------------------
Pathetic.",
	1:"                 You failed
------------------------------------------
I can't believe I trusted you.",
}
var healthdiffnotrunning = true
var oldhealth = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	oldhealth = Global.health
	Global.shotgunshot.connect(Shotguntell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.health != oldhealth and healthdiffnotrunning:
		healthdiff()
	if Global.health <= 0:
		$"../../ColorRect".visible = true
		deathscreen()


func deathscreen():
	$"../../ColorRect".visible = true
	$"../../ColorRect/RichTextLabel".clear()
	var line = randi_range(0,deathlines.size() - 1)
	for x in deathlines[line]:
		$"../../ColorRect/RichTextLabel".add_text(x)
		await get_tree().create_timer(0.01)
func Shotguntell():
	for x in Global.shots:
		print(shoo[x])
		shoo[x].set_modulate(Color(0.349, 0.349, 0.349))
		shoo[x].set_self_modulate(Color(0.4, 0.4, 0.4))
	for x in Global.shots:
		shoo[x].set_modulate(Color(1, 1, 1))
		shoo[x].set_self_modulate(Color(0.4, 0.4, 0.4))
	if Global.shots == 3:
		for x in 3:
			shoo[x].set_modulate(Color(1, 1, 1))
			shoo[x].set_self_modulate(Color(0.4, 0.4, 0.4))


func healthdiff():
	healthdiffnotrunning = false
	var diff = 0
	if Global.health > oldhealth:
		diff = Global.health - oldhealth
	else:
		diff = oldhealth - Global.health
	print(diff)
	for x in diff:
		$"../ProgressBar".value = $"../ProgressBar".value - 1
		await get_tree().create_timer(0.01).timeout
	oldhealth = Global.health
	healthdiffnotrunning = true
