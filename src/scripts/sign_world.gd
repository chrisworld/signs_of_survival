extends Node2D

# signals
signal win_game
signal loose_game

# refs
@onready var sign_world_canvas = $sign_world_canvas
@onready var sign_position_marker = $sign_position_marker
@onready var sign_moving_part = $sign_moving_part
@onready var sign_static_part = $sign_static_part
@onready var character = $character
@onready var cutscene = $cutscene
@onready var starving_timer = $starving_timer

# vars
var is_last_generation = false


func _ready():
	
	# canvas
	sign_world_canvas.hide()

	# static part invisible
	sign_static_part.visible = false

	# last generation reset
	is_last_generation = false

	# reset starving timer
	starving_timer.reset_time()
	

# --
# private methods

func _reset_for_next_generation():

	# reset sign
	sign_moving_part.reset_to_position(sign_position_marker.position)

	# new character
	character.new_generation()

	# sign falling visibles
	sign_static_part.visible = false

	# canvas
	sign_world_canvas.hide_label_watch_out()

	# timer set starving time
	starving_timer.set_staving_time()


# --
# public methods

func reset_sign_world():

	# reset sign
	sign_moving_part.reset_to_position(sign_position_marker.position)

	# reset character
	character.reset()

	# ready stuff
	self._ready()
	

# --
# signals

func _on_sign_sign_falls():

	# sign falling visibles
	sign_static_part.show()
	sign_world_canvas.show_label_watch_out()


func _on_cutscene_cutscene_full_dark():
	
	# reset for next generation
	self._reset_for_next_generation()

	
func _on_character_dead():
	
	# last generation is different
	if is_last_generation:

		# loose cutscene
		loose_game.emit()

	# create cutscene
	cutscene.cutscene_play()


func _on_character_dying():

	# label watch invisible
	sign_world_canvas.hide_label_watch_out()

	# stop time
	starving_timer.stop_counting()


func _on_starving_timer_starved():

	# dies of starving
	character.set_state_dying()


func _on_cutscene_cutscene_finished():
	
	# start timer again
	starving_timer.reset_time()
