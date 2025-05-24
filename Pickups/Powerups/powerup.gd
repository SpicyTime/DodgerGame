class_name Powerup
extends "res://Pickups/pickup.gd"
@export var type: Constants.PowerupType = Constants.PowerupType.HEALTH
@export var duration: float = 5.0

func apply_effect(body):
	if body.has_method("apply_powerup"):
		body.apply_powerup(type)
	
