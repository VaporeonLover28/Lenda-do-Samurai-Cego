extends Node2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_start_button_pressed():
	#get_tree().change_scene_to_file("res://tutorial.tscn")
	get_tree().change_scene_to_file("res://tutorial.tscn")

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://options_menu.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
