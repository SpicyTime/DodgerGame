extends Control

func _on_play_button_pressed() -> void:
	GameManager.is_paused = false
	GameManager.start_game()
