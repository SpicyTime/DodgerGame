class_name Hurtbox
extends Area2D
@export var health: Health
func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var new_health = health.health - area.damage
		health.set_health(new_health)
		SignalBus.received_damage.emit(area.damage)
