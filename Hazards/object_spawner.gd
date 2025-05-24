extends Node2D
 
@onready var timer: Timer = $Timer
var max_x_offset: float = 0
var spawn_delay: Vector2 = Vector2(1, 2.5)
func _ready():
	timer.wait_time = randf_range(spawn_delay.x, spawn_delay.y) 
	timer.start()
func spawn_object():
	var offset = randf_range(-max_x_offset, max_x_offset)
	if GameManager.is_paused:
		return
	var rand = randf()
	var object = null
	if rand < 0.06:
		object = load("res://Pickups/ammo_box.tscn").instantiate()
	else:
		object = load("res://Hazards/falling_object.tscn").instantiate()
	object.position.x += offset
	add_child(object)
	

func _on_timer_timeout() -> void:
	
	spawn_object()
	timer.wait_time = randf_range(spawn_delay.x, spawn_delay.y) 
	timer.start()
