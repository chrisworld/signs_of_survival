extends Node2D

signal last_generation
signal dying
signal dead

# exports
@export var debug_set_to_second_last_generation = false

# generations vars
var generation = 0
var max_generations = 0
var is_blinking = false
var is_dying = false
var is_dead = false
var is_starved = false

# anim die selection
var anim_die_selection = 0
var anim_starve_selection = 0

# refs
@onready var sprites = $body/sprites
@onready var shadow = $body/shadow
@onready var blink_timer = $blink_timer
@onready var blink_duration_timer = $blink_duration_timer
@onready var dead_timer = $dead_timer
@onready var sfx_dying = $sfx_dying
@onready var sfx_dying_special = $sfx_dying_special
@onready var anim = $anim

# anim names
const anim_cavemen_sitting = "cavemen_sitting"
const anim_cavemen_blinking = "cavemen_blinking"
const anim_cavemen_dying = "cavemen_dying"
const anim_cavemen_dying_2 = "cavemen_dying-2"

const anim_die_collection = ["die_v0", "die_v1"]
const anim_starve_collection = ["starve_v0",]

# base blink time
const blink_time_min = 1.0
const blink_time_var = 3.0
const blink_duration_min = 0.2
const blink_duration_var = 0.5
const dying_time = 2.0


func _ready():

	# get all generations
	max_generations = sprites.sprite_frames.get_frame_count(anim_cavemen_sitting) - 1

	# reset
	self.reset()

	# select reandowm die anim
	self._select_random_anim()


# --
# public methods

func reset():

	# vars
	generation = 0 if not debug_set_to_second_last_generation else max_generations - 1
	is_blinking = false
	is_dying = false
	is_dead = false
	is_starved = false
	anim_die_selection = 1

	# reset character animations
	self._character_anim_reset()


func new_generation():

	# add generation
	generation += 1

	# init character
	self._character_anim_reset()

	# determine last generation
	if generation < max_generations: return

	# this is the last generation
	last_generation.emit()

	print("this is the last generation")


func set_state_dying():

	# is already dying
	if is_dying: return

	# set anims
	sprites.animation = anim_cavemen_dying
	sprites.frame = generation

	# hide shadow
	shadow.hide()

	# var and signal
	is_dying = true
	dying.emit()
	print(generation, "-th ", "dies")
	# start new blink timer
	blink_timer.start(2 * blink_duration_min)

	# dead timer
	dead_timer.start(dying_time)

	# starve animation
	if is_starved:
		anim.play(anim_starve_collection[anim_starve_selection])
		return

	# start animation
	anim.play(anim_die_collection[anim_die_selection])


func set_state_starved():

	# overwrite
	is_starved = true

	# set dying
	self.set_state_dying()


func reset_state_dying():
	sprites.animation = anim_cavemen_sitting
	sprites.frame = generation
	is_dying = false


# --
# setter

func set_anim_die_selection(sel : int):
	if sel < 0 and sel > len(anim_die_collection) - 1: return
	anim_die_selection = sel


func set_anim_starve_selection(sel : int):
	if sel < 0 and sel > len(anim_starve_collection) - 1: return
	anim_starve_selection = sel


# --
# getter

func get_generation(): return generation
func get_is_dying(): return is_dying


# --
# private methods

func _select_random_anim():
	self.set_anim_die_selection(randi_range(0, len(anim_die_collection) - 1))
	self.set_anim_starve_selection(randi_range(0, len(anim_starve_collection) - 1))


func _character_anim_reset():

	# alive state
	is_blinking = false
	is_dying = false
	is_dead = false
	is_starved = false

	# set frame
	sprites.frame = generation
	sprites.animation = anim_cavemen_sitting

	# shadow
	shadow.show()

	# start blink timer
	blink_timer.start(blink_time_min)

	# select die anim
	self._select_random_anim()

	# set to start time
	anim.stop()


func _on_blink_timer_timeout():

	# return if dying
	if is_dying: 
		# start new blink timer
		blink_timer.start(2 * blink_duration_min)
		# set duration of blinking
		blink_duration_timer.start(blink_duration_min)
		sprites.animation = anim_cavemen_dying_2
		sprites.frame = generation
		return

	# new blink time
	var new_blink_time = blink_time_min + randf() * blink_time_var
	var new_blink_duration_time = blink_duration_min + randf() * blink_duration_var

	# start new blink timer
	blink_timer.start(new_blink_time)

	# set duration of blinking
	blink_duration_timer.start(new_blink_duration_time)

	# change to blinking anim
	sprites.animation = anim_cavemen_blinking
	sprites.frame = generation


func _on_blink_duration_timer_timeout():

	# return if dying
	if is_dying: 
		sprites.animation = anim_cavemen_dying
		sprites.frame = generation
		return

	# change to sitting anim
	sprites.animation = anim_cavemen_sitting
	sprites.frame = generation


func _on_body_area_entered(_area):
	
	if randi_range(1,10)>1:
		sfx_dying.play()
	else:
		sfx_dying_special.play()
	# init dying
	self.set_state_dying()


func _on_dead_timer_timeout():

	# flags
	is_dead = true

	# signal
	dead.emit()

	# end dead timer
	dead_timer.stop()
