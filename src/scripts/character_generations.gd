extends Node2D


func _on_button_button_down():
	
	# new generation
	$character.new_generation()


func _on_character_last_generation():
	
	# label
	$last_gen_label.visible = true


func _on_dying_button_button_down():
	$character.set_state_dying()


func _on_dying_button_button_up():
	$character.reset_state_dying()
