class_name Pickup
extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		apply_effect(body)
		queue_free()

func apply_effect(body):
	pass
