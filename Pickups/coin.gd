extends "res://Pickups/pickup.gd"

func apply_effect(body):
	if body.has_method("add_coin"):
		body.add_coin()
