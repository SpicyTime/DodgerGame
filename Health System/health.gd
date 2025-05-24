class_name Health
extends Node

@export var health : int = 10 : set = set_health, get = get_health
@export var max_health: int = 10 : set = set_max_health, get = get_max_health
func restore_health():
	set_health(max_health)
func set_health(value: int):
	health = value
	SignalBus.health_changed.emit(health, self)
	if health <= 0:
		SignalBus.health_depleted.emit(self)
		
func set_max_health(value : int):
	max_health = value
	SignalBus.max_health_changed.emit(max_health)

func get_health() -> int:
	return health
	
func get_max_health() -> int:
	return max_health
