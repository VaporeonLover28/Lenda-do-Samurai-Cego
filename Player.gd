extends CharacterBody2D

@export var vida = 5
@export var speed = 200
var can_walk = true
var spritemode = "Samurai_"

enum {IDLE, WALKING}
#Botando o estado inicial como idle
var walkingstate = IDLE

enum {NOINPUT, ATTACKING, BLOCKING}
#Botando o estado inicial como noinput
var inputstate = NOINPUT

func _physics_process(delta):
	
	#print("Movimento: " + str(walkingstate) + ", Ação: " + str(inputstate) + ", Animação: " + str($AnimationPlayer.current_animation))
	
	if Input.is_action_just_pressed("placeholder mode") and spritemode == "Samurai_":
		spritemode = "Igor_"
	
	match spritemode:
		"Samurai_":
			$PlayerSprt.scale.x = 9
			$PlayerSprt.scale.y = 6.09
			$PlayerSprt.offset.x = 6
			$PlayerSprt.offset.y = -25.5
		"Igor_":
			$PlayerSprt.scale.x = 1
			$PlayerSprt.offset.x = 0
			$PlayerSprt.offset.y = 0
	
	if velocity.x < 0 and can_walk:
		$AttackHitbox.scale.x = -1
		$BlockHitbox.scale.x = -1
		$PlayerSprt.flip_h = true
		
	if velocity.x > 0 and can_walk:
		$AttackHitbox.scale.x = 1
		$BlockHitbox.scale.x = 1
		$PlayerSprt.flip_h = false
		
	if vida <= 0:
		get_tree().change_scene_to_file("res://lose_scene.tscn")
	
	match walkingstate:
		IDLE:
			is_idle()
		WALKING:
			is_walking()
	
	match inputstate:
		NOINPUT:
			is_nothing()
		ATTACKING:
			is_attacking()
		BLOCKING:
			is_blocking()
	
	move_and_slide()

func is_idle():
	velocity.x = 0
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		walkingstate = WALKING
	if $AnimationPlayer.current_animation != spritemode + "Attack" and $AnimationPlayer.current_animation != spritemode + "Block" and inputstate == NOINPUT:
		$AnimationPlayer.play(spritemode + "Idle")

func is_walking():
	if $AnimationPlayer.current_animation != spritemode + "Attack" and $AnimationPlayer.current_animation != spritemode + "Block":
		if Input.is_action_pressed("Left"):
			velocity.x = speed * -1
		if Input.is_action_pressed("Right"):
			velocity.x = speed
		if Input.is_action_pressed("Left") == false and Input.is_action_pressed("Right") == false:
			walkingstate = IDLE
		if $AnimationPlayer.current_animation != "Walk":
			$AnimationPlayer.play(spritemode + "Walk")

func is_nothing():
	can_walk = true
	if Input.is_action_just_pressed("Attack") and $AnimationPlayer.current_animation != spritemode + "Block" and $AnimationPlayer.current_animation != spritemode + "Attack":
		inputstate = ATTACKING
	if Input.is_action_just_pressed("Block") and $AnimationPlayer.current_animation != spritemode + "Block" and $AnimationPlayer.current_animation != spritemode + "Attack":
		inputstate = BLOCKING

func is_attacking():
	walkingstate = IDLE
	$BlockHitbox/BlockColl.disabled = true
	can_walk = false
	Attack()

func is_blocking():
	walkingstate = IDLE
	$AttackHitbox/AttackColl.disabled = true
	can_walk = false
	Block()

func Attack():
	if $AnimationPlayer.current_animation != spritemode + ("Attack"): 
		$AnimationPlayer.play(spritemode + "Attack")
		inputstate = NOINPUT
		can_walk = true

func Block():
	if $AnimationPlayer.current_animation != spritemode + ("Block"):
		$AnimationPlayer.play(spritemode + "Block")
		inputstate = NOINPUT
		can_walk = true

#func _on_animation_player_animation_finished(anim_name: StringName):
	#if anim_name == "Attack":
		#print("attackfinished")
	#if anim_name == "Block":
		#print("blockfinished")
#
#func _on_animation_player_animation_started(anim_name: StringName):
	#if anim_name == "Attack":
		#print("attackstarted")
	#if anim_name == "Block":
		#print("blockstarted") a

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Inimigo_hurtbox") == true:
		body.vida -= 1
