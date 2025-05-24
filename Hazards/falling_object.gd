extends Sprite2D
@export var speed: float = 300
@onready var despawn_timer: Timer = $DespawnTimer
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D

@onready var collision_shape_2d2: CollisionShape2D = $Hurtbox/CollisionShape2D

var size: Constants.FallingObjectSize = Constants.FallingObjectSize.SMALL
var pickup: Pickup = null

var size_chances = {
		Constants.FallingObjectSize.LARGE: 0.05,
		Constants.FallingObjectSize.MEDIUM: 0.65,
		Constants.FallingObjectSize.SMALL: 0.30
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
	if rand <= item_spawn_chances[size]:
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
func get_items_in_folder(path: String):
	var items = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".png"):
				items.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	return items
func choose_object_texture() -> Texture2D:
	var size_folder_path: String = ""
	match(size):
		Constants.FallingObjectSize.SMALL:
			size_folder_path = "res://Assets/Sprites/Falling Objects/Small" 
		Constants.FallingObjectSize.MEDIUM:
			size_folder_path = "res://Assets/Sprites/Falling Objects/Medium"
		Constants.FallingObjectSize.LARGE:
			size_folder_path = "res://Assets/Sprites/Falling Objects/Large"
	var textures = get_items_in_folder(size_folder_path)
	var index = randi_range(0, textures.size() - 1)
	return load(size_folder_path + "/" + textures[index])
func spawn_pickup(item):
	pickup = item
	 
func drop_pickup():
	var game_node = get_tree().root.get_node("Game")
	pickup.position = global_position
	 
	game_node.call_deferred("add_child", pickup)
func create_collider():
	if texture and collision_shape_2d and collision_shape_2d.shape is RectangleShape2D:
		var texture_size = texture.get_size()
		var shape := collision_shape_2d.shape as RectangleShape2D
		shape.size = texture_size
		collision_shape_2d2.shape = shape
	else:
		print("Collider or texture not properly set.")

func _ready() -> void:
	SignalBus.health_depleted.connect(_on_health_depleted)
	size = pick_size()
	rotation = randi_range(0, 360)
	texture = choose_object_texture()
	create_collider()
	if should_spawn_item():
		spawn_pickup(choose_powerup())
func _physics_process(delta: float) -> void:
	position.y += speed * delta
	rotation += .015

func _on_despawn_timer_timeout() -> void:
	queue_free()
	
func _on_health_depleted(health_object: Health):
	if health_object == $Health:
		GameManager.set_score(GameManager.score + 1)
		if pickup:
			drop_pickup()
		queue_free()
