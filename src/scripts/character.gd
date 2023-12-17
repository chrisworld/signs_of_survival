extends Node2D

signal last_generation

# generations vars
var generation = 0
var max_generations = 0
var is_blinking = false
var is_dying = false

# refs
@onready var sprites = $sprites 
@onready var blink_timer = $blink_timer
@onready var blink_duration_timer = $blink_duration_timer

# anim names
const anim_cavemen_sitting = "cavemen_sitting"
const anim_cavemen_blinking = "cavemen_blinking"
const anim_cavemen_dying = "cavemen_dying"

# base blink time
const blink_time_min = 1.0
const blink_time_var = 3.0
const blink_duration_min = 0.2
const blink_duration_var = 0.5


# Called when the node enters the scene tree for the first time.
func _ready():

	# inits
	generation = 0
	is_blinking = false

	# set frame
	sprites.frame = generation
	sprites.animation = anim_cavemen_sitting

	# get all generations
	max_generations = sprites.sprite_frames.get_frame_count(anim_cavemen_sitting)

	# start blink timer
	blink_timer.start(blink_time_min)


# --
# public methods

func new_generation():

	# add generation
	generation += 1

	# update frame
	sprites.frame = generation

	# determine last generation
	if generation < max_generations: return

	# this is the last generation
	last_generation.emit()


func set_state_dying():
	sprites.animation = anim_cavemen_dying
	sprites.frame = generation
	is_dying = true


func reset_state_dying():
	sprites.animation = anim_cavemen_sitting
	sprites.frame = generation
	is_dying = false


# --
# private methods

func _on_blink_timer_timeout():

	# return if dying
	if is_dying: return

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


func _on_blink_duration_timers_timeout():

	# return if dying
	if is_dying: return

	# change to sitting anim
	sprites.animation = anim_cavemen_sitting
	sprites.frame = generation
