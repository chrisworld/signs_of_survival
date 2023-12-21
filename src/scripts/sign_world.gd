extends Node2D

# signals
signal win_game
signal loose_game
signal loose_cutscene_full_dark
signal win_cutscene_full_dark

# refs
@onready var background = $background
@onready var sign_world_canvas = $sign_world_canvas
@onready var sign_position_marker = $objects/sign/sign_position_marker
@onready var sign_moving_part = $objects/sign/sign_moving_part
@onready var sign_static_part = $objects/sign/sign_static_part
@onready var character = $objects/character
@onready var survival_girl = $objects/survival_girl
@onready var cutscene = $cutscene
@onready var starving_timer = $starving_timer


# vars
var is_last_generation = false
var is_last_generation_dead = false
var is_survival_girl_coming_for_rescue = false

# win condition
var won_the_game_flag = false


func _ready():
	
	# static part invisible
	sign_static_part.visible = false

	# last generation reset
	is_last_generation = false
	is_last_generation_dead = false

	# win condition
	won_the_game_flag = false


func _process(_delta):

	# actual starving time
	var actual_starving_time = starving_timer.get_actual_starving_time()

	# update
	sign_world_canvas.update_starve_countdown(actual_starving_time)


# --
# public methods

func reset_sign_world():

	# reset sign
	sign_moving_part.reset_to_position(sign_position_marker.position)

	# resets
	character.reset()
	starving_timer.reset()
	sign_world_canvas.reset()
	starving_timer.reset()
	survival_girl.reset()
	
	# reset background
	background.frame = character.get_generation()

	# ready stuff
	self._ready()


func pause_world():

	# stop counting
	starving_timer.stop_counting()


func is_cutscene_playing():
	return cutscene.get_cutscene_play_flag()


# --
# private methods

func _won_sign_world():

	# set win
	won_the_game_flag = true

	# starving time
	starving_timer.stop_counting()

	# freeze
	sign_moving_part.freeze_sign()

	# canvas
	sign_world_canvas.reset()

	# emit
	win_game.emit()


func _reset_for_next_generation():

	# reset sign
	sign_moving_part.reset_to_position(sign_position_marker.position)

	# new character
	character.new_generation()

	# new background
	background.frame = character.get_generation()

	# sign falling visibles
	sign_static_part.visible = false

	# canvas
	sign_world_canvas.reset()

	# timer set starving time
	sign_world_canvas.set_starve_countdown(starving_timer.get_max_starving_time())


# --
# signals

func _on_sign_sign_falls():

	# sign falling visibles
	sign_static_part.show()
	sign_world_canvas.show_label_watch_out()


func _on_cutscene_cutscene_full_dark():

	# in case of winning the game
	if won_the_game_flag:
		win_cutscene_full_dark.emit()
		return

	# label
	sign_world_canvas.hide_label_starved()

	# check if its the last generation who died
	if is_last_generation: 
		loose_cutscene_full_dark.emit()
		return

	# reset for next generation
	self._reset_for_next_generation()
	
	
func _on_character_dead():

	# last generation is different
	if is_last_generation:

		# loose cutscene
		loose_game.emit()
		cutscene.cutscene_play(Enums.SceneType.last_generation_scene)
		is_last_generation_dead = true
		return

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

	# show label
	sign_world_canvas.show_label_starved()


func _on_cutscene_cutscene_finished():

	# last generation died
	if is_last_generation_dead: return

	# start timer again
	starving_timer.reset_time()


func _on_character_last_generation():
	
	# last generation marker
	is_last_generation = true

	# inform starving timer
	starving_timer.last_generation_special()


func _on_starving_timer_survival_girl_appears():

	# survival girl
	is_survival_girl_coming_for_rescue = true
	survival_girl.make_her_visible()


func _on_survival_girl_she_rescues_you():

	# she cannot help you
	if character.get_is_dying(): return

	# win actions
	self._won_sign_world()


func _on_survival_girl_rescuing_anim_done():

	# play win cutscene
	cutscene.cutscene_play(Enums.SceneType.won_the_game_scene)
