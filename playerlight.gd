extends PointLight2D

var growth = 1
var fading = false
var appearing = 1
var fade = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(get_parent().position.x, get_parent().position.y + 50)
	
	$outerdark.scale = scale / 1.25
	$innerlight.scale = scale / 1.5
	$innerdark.scale = scale / 1.75
	
	energy = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if energy < 0:
		energy = 0
	
	if get_parent().name == "Player":
		print("appearing: " + str(appearing) + ", energy: " + str(energy) + ", growth: " + str(growth) + ", fade: " + str(fade))
	
	$outerdark.energy = energy / 1.25
	$innerlight.energy = energy
	$innerdark.energy = energy / 1.25
	
	if appearing > 0 and energy < 1:
		energy += 0.03
		appearing -= 0.03
	
	if fade > 0:
		scale.x += 0.08
		scale.y += 0.08
		growth -= 0.01
	else: 
		reset()
	
	if fading == true and fade > 0:
		energy -= 0.03
		fade -= 0.02

func reset():
	scale = Vector2(1,1)
	energy = 0
	growth = 1
	fading = false
	appearing = 1
	fade = 1
	position = Vector2(get_parent().position.x, get_parent().position.y + 60)
	#position = get_viewport().get_mouse_position()

func _on_fadeout_timeout() -> void:
	fading = true
