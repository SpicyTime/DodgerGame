class_name Pickup
extends RigidBody2D

var speed = 600
func _ready() -> void:
	gravity_scale = 1

func apply_effect(body):
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		apply_effect(body)
		queue_free()
