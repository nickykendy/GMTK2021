extends Area2D

class_name Spike

func _ready() -> void:
	pass


func _on_Spike_body_entered(body : KinematicBody2D) -> void:
	if body:
		if body.is_in_group("Fenny"):
			if body.state == "fall":
				body.die()
