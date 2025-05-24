extends "res://Pickups/Powerups/powerup.gd"

func apply_effect(body):
	if body.has_method("add_health"):
		body.add_health(1)
	
