extends Sprite2D
@export var speed: float = 300
@onready var despawn_timer: Timer = $DespawnTimer
var size: Constants.FallingObjectSize = Constants.FallingObjectSize.SMALL
var pickup: Pickup = null

var size_chances = {
		Constants.FallingObjectSize.LARGE: 0.5,
		Constants.FallingObjectSize.MEDIUM: 0.15,
		Constants.FallingObjectSize.SMALL: 0.35
}
var item_spawn_chances = {
	Constants.FallingObjectSize.LARGE: 0.3,
	Constants.FallingObjectSize.MEDIUM: 0.1,
	Constants.FallingObjectSize.SMALL: 0.05
}
func pick_size():
	var rand = randf()
	var cumulative = 0.0
	for object_size in size_chances.keys():
		cumulative +=  size_chances[object_size]
		if rand <= cumulative:
			return object_size
	return size_chances.keys().back()
func apply_size():
	var object_size = pick_size()
	size = object_size
	match(size): 
		Constants.FallingObjectSize.LARGE:
			scale = Vector2(1.05, 1.05)
		Constants.FallingObjectSize.MEDIUM:
			scale = Vector2(0.75, 0.75)
		Constants.FallingObjectSize.SMALL:
			scale = Vector2(0.5, 0.5)
			
func should_spawn_item() -> bool:
	var rand = randf()
	if rand <= 1:
		return true
	return false
func choose_powerup():
	var types_size = Constants.PowerupType.keys().size()
	var index = randi_range(0, types_size - 1)
	var random_key = Constants.PowerupType.keys()[index]
	var random_type = Constants.PowerupType[random_key]
	var scene_path = Constants.type_to_scene[random_type]
	 
	var scene = load(scene_path).instantiate()
	 
	return scene
func spawn_pickup(item):
	pickup = item
	add_child(item)
func drop_pickup():
	var game_node = get_tree().root.get_node("Game")
	pickup.position = global_position
	remove_child(pickup)
	game_node.call_deferred("add_child", pickup)
func _ready() -> void:
	SignalBus.health_depleted.connect(_on_health_depleted)
	apply_size()
	
	if should_spawn_item():
		spawn_pickup(choose_powerup())
func _physics_process(delta: float) -> void:
	position.y += speed * delta
	

func _on_despawn_timer_timeout() -> void:
	queue_free()
	
func _on_health_depleted(health_object: Health):
	if health_object == $Health:
		GameManager.set_score(GameManager.score + 1)
		if pickup:
			drop_pickup()
		queue_free()
