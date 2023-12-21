extends CanvasLayer

signal end_credits


func _process(_delta):
	
	# escape
	if Input.is_action_just_pressed("escape"):

		# check visibility
		if not self.visible: return

		# signal
		end_credits.emit()
		print("esc credits")


func _on_back_button_button_up():
	end_credits.emit()
