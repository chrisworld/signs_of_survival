extends Node2D

@onready var cutscene_check_button = $canvas/buttons/cutcene_check_button

func _on_gen_button_button_down():
	
	if cutscene_check_button.button_pressed:
		
		# cutscene
		$cutscene.cutscene_play()
		return
		
	# change character
	$character.new_generation()
	

func _on_character_last_generation():
	
	# label
	$canvas/last_gen_label.visible = true


func _on_dying_button_button_down():
	
	# set state dying
	$character.set_state_dying()


func _on_dying_button_button_up():
	
	# reset state dying
	$character.reset_state_dying()


func _on_cutscene_cutscene_full_dark():
	
	# change character
	$character.new_generation()

