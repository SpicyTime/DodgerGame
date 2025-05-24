extends Node
var score: int = 0 : set = set_score
var game_time: float = 0
var is_paused = true
var game = null
func set_score(new_score):
	score = new_score
	SignalBus.score_changed.emit(score)
func start_game():
	var hud: Control = load("res://GUI/hud.tscn").instantiate()
	#game.add_child(hud)
	#set_score(0)
	var title_screen =game.find_child("TitleScreen")
	game.remove_child(title_screen)
func _ready() -> void:
	print(get_tree().root.get_children())
	game = get_tree().root.get_node("Game")
	SignalBus.player_dead.connect(_on_player_death)
	var spawner = game.find_child("ObjectSpawner")
	spawner.max_x_offset = get_viewport().get_visible_rect().size.x / 2
func _process(delta: float) -> void:
	game_time += delta
	
func _on_player_death() -> void:
	is_paused = true
	var death_screen = load("res://GUI/death_screen.tscn").instantiate()
	game.add_child(death_screen)
	var score_label: Label = death_screen.get_node("VBoxContainer/FinalScoreLabel")
	var time_label: Label = death_screen.get_node("VBoxContainer/TimeLabel")
	
	score_label.text = "Score: " + str(score)
	time_label.text = "Time Survived: " + str(snapped(game_time, 0.001))
