extends CanvasLayer

onready var big : = $head/big
onready var small : = $head/small
onready var time : = $head/Time
onready var emit : = $emit
onready var emitter : = $emit/Emitter
onready var emi_pos : = $emit/Emitter/Position2D
onready var emi_ray : = $emit/Emitter/RayCast2D
onready var fail : = $fail
onready var win : = $win
onready var menu : = $menu
onready var score : = $win/Label

onready var num1 : = preload("res://Sprites/HUD/colored_transparent_packed853.png")
onready var num2 : = preload("res://Sprites/HUD/colored_transparent_packed854.png")
onready var num3 : = preload("res://Sprites/HUD/colored_transparent_packed855.png")
onready var num4 : = preload("res://Sprites/HUD/colored_transparent_packed856.png")
onready var num5 : = preload("res://Sprites/HUD/colored_transparent_packed857.png")
onready var num6 : = preload("res://Sprites/HUD/colored_transparent_packed858.png")
onready var num7 : = preload("res://Sprites/HUD/colored_transparent_packed859.png")
onready var num8 : = preload("res://Sprites/HUD/colored_transparent_packed860.png")
onready var num9 : = preload("res://Sprites/HUD/colored_transparent_packed861.png")
onready var num0 : = preload("res://Sprites/HUD/colored_transparent_packed852.png")

onready var fenny : = preload("res://Scenes/Fenny.tscn")

var soul : = 0 setget set_soul
var isEmitter : = false setget set_emitter
var isFail : = false setget set_fail
var canSpawn : = true setget set_can_spawn
var speed : = 150
var timeNum : = 0


func _ready() -> void:
	set_fail(false)
	display_soul_num()
	set_emitter(false)
	offset = Vector2(0, 0)


func display_soul_num() -> void:
	var bigNum = soul/10
	var smallNum = soul%10
	small.texture = _match_num(smallNum)
	big.texture = _match_num(bigNum)


func _physics_process(delta : float) -> void:
	if isEmitter and !isFail:
		var _right = Input.is_action_pressed("right")
		var _left = Input.is_action_pressed("left")
		var _down = Input.is_action_just_pressed("down")
		var dir = int(_right) - int(_left)
		emitter.position.x += speed * dir * delta
		emitter.position.x = clamp(emitter.position.x, 8, 312)
			
		if _down and canSpawn:
			if soul > 0:
				var ls = get_tree().get_nodes_in_group("Level")
				if ls[0]:
					var f = fenny.instance()
					ls[0].add_child(f)
					var _offset = ls[0].cam.position
					f.global_position = emi_pos.global_position + _offset
					f.set_physics_process(false)
					var val = soul - 1
					set_soul(val)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if menu.visible == false:
			menu.visible = true
		else:
			menu.visible = false


func set_soul(value) -> void:
	soul = value
	display_soul_num()


func _match_num(value : int) -> StreamTexture:
	var spr : StreamTexture
	match value:
		0:
			spr = num0
		1:
			spr = num1
		2:
			spr = num2
		3:
			spr = num3
		4:
			spr = num4
		5:
			spr = num5
		6:
			spr = num6
		7:
			spr = num7
		8:
			spr = num8
		9:
			spr = num9
	return spr


func set_emitter(value) -> void:
	isEmitter = value
	if isEmitter:
		emit.visible = true
	else:
		emit.visible = false


func set_fail(value : bool) -> void:
	isFail = value
	fail.visible = value


func set_can_spawn(value : bool) -> void:
	canSpawn = value
	if canSpawn:
		emitter.modulate = Color( 1, 1, 1, 1 )
	else:
		emitter.modulate = Color( 1, 0, 0, 1 )

func _on_Button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_Timer_timeout() -> void:
	timeNum += 1
	var minute = timeNum / 60
	var second = timeNum % 60
	var strMin
	var strSec
	
	if minute < 10:
		strMin = "0" + String(minute)
	else:
		strMin = String(minute)
	
	if second < 10:
		strSec = "0" + String(second)
	else:
		strSec = String(second)
	time.text = strMin + ":" + strSec


func calculate_score(num : int) -> void:
	var scoreFenny : = num * 10
	var scoreTime : = (300 - timeNum) * 2
	var scoreSoul : = soul * 10
	var scoreTotal : = scoreFenny + scoreTime + scoreSoul
	score.text = String(scoreTotal)
