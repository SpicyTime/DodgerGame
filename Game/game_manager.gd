extends Node
var objects_destroyed: int = 0 : set = set_destroyed_objects
var game_time: float = 0
var is_paused = true
var object_fall_speed = 350
var current_difficulty = 0
var threshold = 10
func set_destroyed_objects(new_count):
	objects_destroyed = new_count
	SignalBus.score_changed.emit()
	
func start_game():
	 
	var game = get_tree().root.get_node("Game") 
	var title_screen = game.find_child("TitleScreen")
	game.remove_child(title_screen)
func reset_game():
	get_tree().reload_current_scene()
	 
func increase_difficulty():
	var game = get_tree().root.get_node("Game") 
	var spawner_holder = game.find_child("ObjectSpawners")
	var spawners = spawner_holder.get_children()
	for spawner in spawners:
		spawner.spawn_delay *= 0.9
	object_fall_speed *= 1.15
 
func _ready() -> void:
	
	SignalBus.player_dead.connect(_on_player_death)
	 
func _process(delta: float) -> void:
	if is_paused:
		return
	game_time += delta
	if game_time > threshold:
		threshold += 15
		increase_difficulty()
func _on_player_death() -> void:
	is_paused = true
	var death_screen = load("res://GUI/death_screen.tscn").instantiate()
	var game = get_tree().root.get_node("Game")
	game.add_child(death_screen)
	var score_label: Label = death_screen.get_node("VBoxContainer/FinalScoreLabel")
	var time_label: Label = death_screen.get_node("VBoxContainer/TimeLabel")
	var score  = (objects_destroyed * 100) + roundi(game_time / 10) * 10 
	
	print(score)
	score_label.text = "Score: " + str(score)
	time_label.text = "Time Survived: " + str(snapped(game_time, 0.001))
