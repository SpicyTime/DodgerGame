extends "res://Pickups/pickup.gd"

func apply_effect(body):
	if body.has_method("add_bullets"):
		body.add_bullets(15)
