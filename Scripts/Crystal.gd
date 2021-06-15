extends Area2D

onready var col = $CollisionShape2D
onready var anim = $AnimationPlayer

func _on_Crystal_body_entered(body : KinematicBody2D) -> void:
	if body and body.is_in_group("Fenny"):
		col.queue_free()
		body.pick_up()
		anim.play("fade")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
