extends Sprite2D
var speed: float = 400
@onready var despawn_timer: Timer = $DespawnTimer
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D

@onready var collision_shape_2d2: CollisionShape2D = $Hurtbox/CollisionShape2D

var size: Constants.FallingObjectSize = Constants.FallingObjectSize.SMALL
var pickup: Pickup = null

var destroy_sound: AudioStream = preload("res://Assets/Audio/SFX/ObjectExplosion.mp3")
var item_spawn_chances = {
	Constants.FallingObjectSize.LARGE: 0.3,
	Constants.FallingObjectSize.MEDIUM: 0.1,
	Constants.FallingObjectSize.SMALL: 0.05
}
var pickup_chances = {
	"Coin": 0.2,
	"Ammo": 0.3,
	"Powerup": 0.5
}

func set_speed(new_speed):
	speed = new_speed

func should_spawn_item() -> bool:
	var rand = randf()
	if rand <= item_spawn_chances[size]:
		return true
	return false
	
func choose_powerup() -> Powerup:
	var types_size = Constants.PowerupType.keys().size()
	var index = randi_range(0, types_size - 1)
	var random_key = Constants.PowerupType.keys()[index]
	var random_type = Constants.PowerupType[random_key]
	var scene_path = Constants.type_to_scene[random_type]
	 
	var scene = load(scene_path).instantiate()
	 
	return scene
func choose_pickup() -> String:
	var rand = randf()
	var cumulative = 0.0
	for pickup in pickup_chances:
		cumulative += pickup_chances[pickup]
		if rand <= cumulative:
			return pickup
	return pickup_chances.keys().back()
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
func set_health_and_hit():
	var hitbox: Hitbox = $Hitbox
	var health: Health = $Health
	match(size):
		Constants.FallingObjectSize.SMALL:
			hitbox.set_damage(1)
			health.set_max_health(1)
			health.set_health(1)
		Constants.FallingObjectSize.MEDIUM:
			hitbox.set_damage(2)
			health.set_max_health(2)
			health.set_health(2)
		Constants.FallingObjectSize.LARGE:
			hitbox.set_damage(4)
			health.set_max_health(4)
			health.set_health(4)
func set_up_object():
	texture = choose_object_texture()
	create_collider()
	set_health_and_hit()
func _ready() -> void:
	SignalBus.health_depleted.connect(_on_health_depleted)
	 
	rotation = randi_range(0, 360)
	
	if should_spawn_item():
		var result = choose_pickup()
		if result == "Powerup":
			spawn_pickup(choose_powerup())
		elif result == "Ammo":
			pickup = load("res://Pickups/ammo_box.tscn").instantiate()
		else:
			pickup = load("res://Pickups/coin.tscn").instantiate()
			
func _physics_process(delta: float) -> void:
	position.y += speed * delta
	rotation += .015

func _on_despawn_timer_timeout() -> void:
	queue_free()
	
func _on_health_depleted(health_object: Health):
	if health_object == $Health:
		GameManager.set_destroyed_objects(GameManager.objects_destroyed + 1)
		if pickup:
			drop_pickup()
		AudioManager.play_sfx(destroy_sound, "SFX", 5.0)
		queue_free()
