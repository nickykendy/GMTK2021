extends Node2D

func _process(delta):
	if Input.is_mouse_button_pressed(1):
		get_tree().change_scene("res://Levels/Level.tscn")
