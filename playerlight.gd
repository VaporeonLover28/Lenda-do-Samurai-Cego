extends PointLight2D

var growth = 1
var fading = false
var appearing = 1
var fade = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$outerdark.scale = scale / 1.25
	$innerlight.scale = scale / 1.5
	$innerdark.scale = scale / 1.75
	
	energy = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$outerdark.energy = energy / 1.25
	$innerlight.energy = energy
	$innerdark.energy = energy / 1.25
	
	if appearing > 0 and energy < 1:
		energy += 0.01
		appearing -= 0.01
	
	if growth > 0:
		scale.x += 0.03
		scale.y += 0.03
		growth -= 0.01
	else: 
		queue_free()
	
	if fading == true and fade > 0:
		energy -= 0.01
		fade -= 0.01

func _on_fadeout_timeout() -> void:
	fading = true
