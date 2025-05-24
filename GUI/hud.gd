extends Control
@onready var score_label: Label = $ScoreLabel




func _ready() -> void:
	SignalBus.score_changed.connect(_on_score_changed)
	 
	 
func _on_score_changed(new_score: int):
	score_label.text = "Score: " + str(new_score)
