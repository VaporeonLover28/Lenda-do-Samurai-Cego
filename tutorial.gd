extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if KillsCounter.enemies_killed == 10:
		get_tree().change_scene_to_file("res://win_scene.tscn")
		KillsCounter.enemies_killed = 0
