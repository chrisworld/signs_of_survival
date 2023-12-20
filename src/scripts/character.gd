extends Node2D

signal last_generation
signal dying
signal dead

# generations vars
var generation = 0
var max_generations = 0
var is_blinking = false
var is_dying = false
var is_dead = false

# refs
@onready var sprites = $sprites 
@onready var blink_timer = $blink_timer
@onready var blink_duration_timer = $blink_duration_timer
@onready var dead_timer = $dead_timer

# anim names
const anim_cavemen_sitting = "cavemen_sitting"
const anim_cavemen_blinking = "cavemen_blinking"
const anim_cavemen_dying = "cavemen_dying"
const anim_cavemen_dying_2 = "cavemen_dying-2"

# base blink time
const blink_time_min = 1.0
const blink_time_var = 3.0
const blink_duration_min = 0.2
const blink_duration_var = 0.5
const dying_time = 2.0


func _ready():

	# get all generations
	max_generations = sprites.sprite_frames.get_frame_count(anim_cavemen_sitting)

	# reset
	self.reset()



# --
# public methods

func reset():

	# vars
	generation = 0
	is_blinking = false
	is_dying = false
	is_dead = false

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


func set_state_dying():

	# is already dying
	if is_dying: return

	# set anims
	sprites.animation = anim_cavemen_dying
	sprites.frame = generation

	# var and signal
	is_dying = true
	dying.emit()
	print("dies")
	# start new blink timer
	blink_timer.start(2 * blink_duration_min)

	# dead timer
	dead_timer.start(dying_time)


func reset_state_dying():
	sprites.animation = anim_cavemen_sitting
	sprites.frame = generation
	is_dying = false


# --
# private methods

func _character_anim_reset():

	# alive state
	is_blinking = false
	is_dying = false
	is_dead = false

	# set frame
	sprites.frame = generation
	sprites.animation = anim_cavemen_sitting

	# start blink timer
	blink_timer.start(blink_time_min)


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
	
	# init dying
	self.set_state_dying()


func _on_dead_timer_timeout():

	# flags
	is_dead = true

	# signal
	dead.emit()

	# end dead timer
	dead_timer.stop()
