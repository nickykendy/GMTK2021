extends Node2D

onready var cam : = $Camera2D
onready var canvas : = $Canvas
onready var spawntut : = $Tutorial/SpawnTut
onready var ray : = $RayCast2D
onready var arrow : = preload("res://Sprites/HUD/colored_transparent_packed518.png")
onready var sword : = preload("res://Sprites/HUD/colored_transparent_packed465.png")

var isEmitter : = false setget set_isEmitter
var isTutOpen : = false


func _on_Fenny_update_cam(pos : Vector2) -> void:
	cam.global_position = pos
	check_penny_out_screen()


func _on_Fenny_find_survivor() -> void:
	var fennys = get_tree().get_nodes_in_group("Fenny")
	for fenny in fennys:
		if fenny.is_alive:
			fenny.is_connect = true


func set_isEmitter(value) -> void:
	isEmitter = value
	canvas.isEmitter = value


func _process(delta):
	if canvas.isEmitter:
		var offset = cam.global_position
		ray.global_position = canvas.emitter.global_position + offset
		ray.enabled = true
		var collider = ray.get_collider()
		if collider and (collider.is_in_group("Zone") or collider.is_in_group("Fenny")):
			canvas.canSpawn = false
		else:
			canvas.canSpawn = true
	else:
		ray.enabled = false
	
	if isTutOpen:
		var fennys = get_tree().get_nodes_in_group("Fenny")
		var isSword : = false
		for fenny in fennys:
			if fenny.is_alive and get_global_mouse_position().distance_to(fenny.global_position) <= 8:
				isSword = true
				if Input.is_mouse_button_pressed(1):
					fenny.recycle()
		
		if isSword:
			Input.set_custom_mouse_cursor(sword)
		else:
			Input.set_custom_mouse_cursor(arrow)


func _input(event):
	if event.is_action_pressed("switch") and !canvas.isFail:
		var fennys = get_tree().get_nodes_in_group("Fenny")
		if isEmitter:
			set_isEmitter(false)
			spawntut.visible = false
			for fenny in fennys:
				fenny.set_physics_process(true)
		else:
			set_isEmitter(true)
			spawntut.visible = true
			for fenny in fennys:
				fenny.set_physics_process(false)


func check_penny_out_screen() -> void:
	var fennys = get_tree().get_nodes_in_group("Fenny")
	for fenny in fennys:
		if fenny.is_alive:
			var grid_pos = fenny.get_grid_pos()
			if grid_pos != cam.position:
				fenny.is_connect = false
			else:
				fenny.is_connect = true
			
			if grid_pos.distance_to(cam.position) > 320:
				fenny.recycle()


func check_fail_condition() -> void:
	var result : = true
	var fennys = get_tree().get_nodes_in_group("Fenny")
	for fenny in fennys:
		if fenny.is_alive:
			result = false
			break
	
	if result and canvas.soul == 0:
		canvas.isFail = result


func check_fenny_num() -> void:
	var fennys = get_tree().get_nodes_in_group("Fenny")
	var index = 0
	for fenny in fennys:
		if !fenny.is_alive:
			if fennys.size() > 20:
				fenny.queue_free()
				fennys.remove(index)
		index += 1


func _on_Tut_body_entered(body : KinematicBody2D) -> void:
	if body and body.is_in_group("Fenny") and !isTutOpen:
		isTutOpen = true


func _on_Final_body_entered(body : KinematicBody2D) -> void:
	if body and body.is_in_group("Fenny"):
		var fennys = get_tree().get_nodes_in_group("Fenny")
		var num = 0
		for fenny in fennys:
			if fenny.is_alive:
				num += 1
		canvas.win.visible = true
		canvas.calculate_score(num)
