extends Hitbox
@export var speed = 250
var direction: Vector2
 
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
 


func _on_area_entered(area: Area2D) -> void:
	if area != self  :
		queue_free()
	

func _on_despawn_timer_timeout() -> void:
	if is_instance_valid(self):
		queue_free()


 
