extends Node2D

# refs
@onready var character = $character
@onready var cutscene_check_button = $canvas/buttons/cutcene_check_button
@onready var die_anim_selector = $canvas/buttons/die_anim_selector


func _ready():

	# default selection
	character.set_anim_die_selection(die_anim_selector.selected)
	

func _on_gen_button_button_down():
	
	if cutscene_check_button.button_pressed:
		
		# cutscene
		$cutscene.cutscene_play()
		return
		
	# change character
	character.new_generation()
	

func _on_character_last_generation():
	
	# label
	$canvas/last_gen_label.visible = true


func _on_dying_button_button_down():
	
	# set state dying
	character.set_state_dying()


func _on_dying_button_button_up():
	
	# reset state dying
	character.reset_state_dying()


func _on_cutscene_cutscene_full_dark():
	
	# change character
	character.new_generation()


func _on_die_anim_selector_item_selected(index):
	character.set_anim_die_selection(index)
