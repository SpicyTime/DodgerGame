extends Control
 
func update_hearts(max_health: int,  current_health: int):
	for i in range(max_health):
		var heart =$Hearts.get_child(i) as TextureRect
		 
		if heart:
			heart.visible = i < current_health 
func _ready() -> void:
 
	SignalBus.health_changed.connect(_on_health_changed)
	for i in range(3):
		var heart := TextureRect.new()
		heart.texture = load("res://Assets/Sprites/Heart.png")
		heart.scale = Vector2(0.66666667, 0.66666667)
		$Hearts.add_child(heart)
		
func _on_health_changed(diff: int, health_node: Health):
	if health_node.get_parent() is Player:
		print(health_node.health)
		update_hearts(health_node.max_health, health_node.health)
 
 
