extends KinematicBody2D

class_name Fenny

var speed : = 5000.0
var motion : = Vector2()
var gravity : = 9.8
var jump_height : = 100.0
var jump_max_height : = 235.0
var state : = "idle" setget set_state
var is_alive : = true
var is_connect : = true
var width : = 320.0
var height : = 200.0

onready var anim : = $AnimatedSprite
onready var col : = $CollisionShape2D
onready var world : = get_parent()

signal update_cam
signal find_survivor


func _ready() -> void:
	connect("update_cam", world, "_on_Fenny_update_cam")
	connect("find_survivor", world, "_on_Fenny_find_survivor")


func _physics_process(delta : float) -> void:
	var grid_pos = get_grid_pos()
	if is_alive and is_connect:
		if world and world.cam.global_position != grid_pos:
			emit_signal("update_cam", grid_pos)
	_get_input(delta)


func _get_input(delta) -> void:
	if is_alive:
		var _right : = Input.is_action_pressed("right")
		var _left : = Input.is_action_pressed("left")
		var _jump : = Input.is_action_pressed("up")
		var _jump_released : = Input.is_action_just_released("up")
		var _down : = Input.is_action_pressed("down")
		
		motion.x = (int(_right) - int(_left)) * speed * delta
		
		if _jump and is_on_floor() and is_alive:
			motion.y = -jump_max_height
			set_state("jump")
		else:
			motion.y += gravity
			if !is_on_floor():
				set_state("fall")
			else:
				if motion.x != 0:
					set_state("move")
				else:
					set_state("idle")
	else:
		motion.x = 0
		if !is_on_floor():
			motion.y += gravity
	
	motion = move_and_slide(motion, Vector2.UP)


func set_state(newState : String) -> void:
	if newState == state:
		return
	
	state = newState
	if newState == "idle":
		anim.play("idle")
	elif newState == "move":
		anim.play("move_right")
		if motion.x > 0:
			anim.flip_h = false
		else:
			anim.flip_h = true
	elif newState == "jump":
		anim.play("jump")
	elif newState == "fall":
		anim.play("fall")
	else:
		anim.play("die")


func die() -> void:
	if is_alive:
		set_collision_mask_bit(0, 0)
		set_state("die")
		is_alive = false
		if world:
			world.check_fail_condition()
#			world.check_fenny_num()
		
		emit_signal("find_survivor")


func recycle() -> void:
	if is_alive:
		is_alive = false
		if world:
			world.canvas.soul += 1
			set_state("die")
			yield(get_tree().create_timer(2.0), "timeout")
			queue_free()


func pick_up() -> void:
	if world:
		world.canvas.soul += 1
	

func get_grid_pos() -> Vector2:
	var _x = floor(global_position.x / width) * width
	var _y = floor(global_position.y / height) * height
	return Vector2(_x, _y)
