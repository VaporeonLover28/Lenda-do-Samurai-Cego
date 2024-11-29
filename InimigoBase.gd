extends CharacterBody2D; class_name Inimigo

@export_category("status inimigo")
@export var velocidade : int
@export_enum("esquerda", "direita") var lado : int
@export var dano : int
@export var max_vida : float = 1
@export var vida : int
@export var idletoatktimer : int
@onready var light = preload("res://playerlight.tscn")
var playerinsideatk = false
var reduction = 0
var baserotation = PI
var windup = baserotation
var colorwindup = 0
var playerblockinsarea = false
var canstep = true
var ladosimplifier = 0
var goto = Vector2(position.x + 50, position.y)

enum {IDLE, WALKING, HURT}
var walking_state = IDLE

enum {NOATK, ATTACK}
var input_state = NOATK

func _ready():
	
	var light_inst = light.instantiate()
	add_child(light_inst)
	vida = max_vida
	$IdleToAtkTimer.wait_time = idletoatktimer
	#$IdleToAtkTimer.timeout.connect(Func_IdleToAtkTimer)
	
	if lado == 0:
		walking_state = WALKING
		$fot1.bus = "lefiti"
		$fot2.bus = "lefiti"
		$fot1.max_distance = 750
		$fot2.max_distance = 750
		$InimigoAttackDetection.scale.x = -1
		$InimigoAttackHitbox.scale.x = -1
		$InimigoSpr.flip_h = true
		self.velocidade *= -1
		goto *= -1
		ladosimplifier = -1
	
	if lado == 1:
		await get_tree().create_timer(0.25).timeout
		walking_state = WALKING
		$fot1.bus = "rraite"
		$fot2.bus = "rraite"
		$fot1.max_distance = -750
		$fot2.max_distance = -750
		$InimigoAttackDetection.scale.x = 1
		$InimigoAttackHitbox.scale.x = 1
		$InimigoSpr.flip_h = false
		goto *= 1
		ladosimplifier = 1
	
	goto = position.x + 50 * ladosimplifier

func _physics_process(delta):
	
	#print("Movimento: " + str(walking_state) + \
	#", Ação: " + str(input_state) + \
	#", Animação: " + str($InimigoAnim.current_animation) \
	#+ ", Detectando: " + str(playerinsideatk))
	
	if reduction > 0:
		if lado == 1:
			position.x -= 3
		else:
			position.x += 3
		reduction -= 1
	
	if $IdleToAtkTimer.is_stopped() == false:
		colorwindup += 0.01
		if lado == 1:
			windup -= 0.01
		else:
			windup += 0.01
	
	$InimigoSpr.rotation = windup
	$InimigoSpr.modulate.s = colorwindup
	
	if vida <= 0:
		KillsCounter.enemies_killed += 1
		max_vida += 0.5
		vida = floor(max_vida)
		if lado == 1:
			position.x = -300
		else:
			position.x = 1452
	
	match walking_state:
		IDLE:
			is_idle()
		WALKING:
			is_walking()
		HURT:
			is_hurt()
	match input_state:
		NOATK:
			is_nothing()
		ATTACK:
			is_attacking()
	move_and_slide()

func steps():
	print(position)
	print(goto)
	canstep = false
	if $fot1.playing == false:
		$fot1.play()
		position = position.lerp(goto, 0.1)
	await get_tree().create_timer(1).timeout
	if $fot2.playing == false:
		$fot2.play()
		position = position.lerp(goto, 0.1)
	await get_tree().create_timer(1).timeout
	canstep = true

func is_idle():
	velocity.x = 0
	if $IdleToAtkTimer.is_stopped():
		$IdleToAtkTimer.start()
	if $InimigoAnim.current_animation != "attack":
		$InimigoAnim.play("walking")

func is_walking():
	steps()
	windup = baserotation
	colorwindup = 0
	if $InimigoAnim.current_animation != "attack":
		$InimigoAnim.play("walking")

func is_hurt():
	if vida > 0:
		$InimigoAnim.play("hurt")
	else:
		pass

func is_nothing():
	pass

func is_attacking():
	if $InimigoAnim.current_animation != "attack":
		$InimigoAnim.play("attack")
		windup = baserotation
		colorwindup = 0
		input_state = NOATK
		walking_state = IDLE

func _on_inimigo_attack_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		walking_state = IDLE
		playerinsideatk = true

func _on_inimigo_attack_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		playerinsideatk = false

func _on_idle_to_atk_timer_timeout() -> void:
	if playerinsideatk == true:
		input_state = ATTACK
		walking_state = IDLE
	else:
		input_state = NOATK
		walking_state = WALKING

func _on_inimigo_attack_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Block_collision") == true:
		playerblockinsarea = true
	if playerblockinsarea == true:
		print("bloqueou")
		reduction = 50
	elif playerblockinsarea == false and area.is_in_group("Player_hurtbox") == true:
		area.get_parent().vida -= 1
	else:
		print("errou vacilao")
