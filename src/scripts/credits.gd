extends CanvasLayer

signal end_credits


func _process(_delta):
	
	# escape
	if Input.is_action_just_pressed("escape"):

		# signal
		end_credits.emit()


func _on_back_button_button_up():
	end_credits.emit()
