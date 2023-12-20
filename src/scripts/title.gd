extends CanvasLayer

signal start_game
signal end_game
signal credits

# --
# signals

func _on_start_button_up():
	start_game.emit()


func _on_credits_button_up():
	credits.emit()


func _on_end_button_up():
	end_game.emit()
