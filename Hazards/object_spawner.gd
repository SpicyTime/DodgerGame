extends Node2D
 
@onready var timer: Timer = $Timer
var max_x_offset: float = 0
var spawn_delay: Vector2 = Vector2(1, 2.5)
 
var size_chances = {
		Constants.FallingObjectSize.LARGE: 0.05,
		Constants.FallingObjectSize.MEDIUM: 0.65,
		Constants.FallingObjectSize.SMALL: 0.30
}
func pick_size():
	var rand = randf()
	var cumulative = 0.0
	for object_size in size_chances.keys():
		cumulative +=  size_chances[object_size]
		if rand <= cumulative:
			return object_size
	return size_chances.keys().back()
func _ready():
	timer.wait_time = randf_range(spawn_delay.x, spawn_delay.y) 
	timer.start()
	max_x_offset = get_viewport().get_visible_rect().size.x / 2
func spawn_object():
	if GameManager.is_paused:
		return
	var offset = randf_range(1.0, max_x_offset)
	if randf() < 0.5:
		offset *= -1
		 
	
	var rand = randf()
	var object = null
	if rand < 0.06:
		object = load("res://Pickups/ammo_box.tscn").instantiate()
		
	else:
		object = load("res://Hazards/falling_object.tscn").instantiate()
		 
		object.set_speed(GameManager.object_fall_speed)
		object.size = pick_size()
		object.call_deferred("set_up_object")
	object.position.x += offset
	
	add_child(object)
	

func _on_timer_timeout() -> void:
	
	spawn_object()
	timer.wait_time = randf_range(spawn_delay.x, spawn_delay.y) 
	timer.start()
	 
