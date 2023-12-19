extends Node2D

# refs
@onready var label_watch_out = $canvas/label_watch_out
@onready var sign_position_marker = $sign_position_marker
@onready var sign_moving_part = $sign_moving_part
@onready var sign_static_part = $sign_static_part
@onready var character = $character
@onready var cutscene = $cutscene
@onready var starving_timer = $starving_timer


func _ready():

	# static part invisible
	sign_static_part.visible = false
	

# --
# private methods

func _reset_for_next_generation():

	# reset sign
	sign_moving_part.reset_to_position(sign_position_marker.position)

	# new character
	character.new_generation()

	# sign falling visibles
	sign_static_part.visible = false
	label_watch_out.visible = false

	# timer set starving time
	starving_timer.set_staving_time()
	

# --
# signals

func _on_sign_sign_falls():

	# sign falling visibles
	sign_static_part.visible = true
	label_watch_out.visible = true


func _on_cutscene_cutscene_full_dark():
	
	# reset for next generation
	self._reset_for_next_generation()

	
func _on_character_dead():
	
	# create cutscene
	cutscene.cutscene_play()


func _on_character_dying():

	# label watch invisible
	label_watch_out.visible = false

	# stop time
	starving_timer.stop_counting()


func _on_starving_timer_starved():

	# dies of starving
	character.set_state_dying()


func _on_cutscene_cutscene_finished():
	
	# start timer again
	starving_timer.reset_time()
