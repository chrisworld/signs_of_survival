extends Node2D

# signals
signal starved
signal survival_girl_appears

# exports
@export var starve_time = 30.0

# refs
@onready var timer = $Timer
@onready var label_time = $canvas/label_starve/label_starve_time

# resources
@onready var label_setting_time_normal = load("res://themes/my_label_settings.tres")
@onready var label_setting_time_highlight = load("res://themes/my_r_label_settings.tres")

# starved
var is_starved = false

# last generation special
var last_generation_special_flag = false
var survival_girl_appeared = false
var is_highlighting_count_down = false

# const
const highlight_count_down_at_time = 10.0
const survival_girl_appear_time = 10.0


func _ready():

	# reset
	self.reset()


func _process(_delta):

	# do not process this
	if is_starved: return
	if timer.is_stopped(): return

	# actual time
	var actual_time = timer.get_time_left()

	# update time
	label_time.text = str(int(actual_time))

	# highlight
	if not is_highlighting_count_down:

		# highlight on
		if actual_time < highlight_count_down_at_time: self._highlight_starve_time_on()

	# specialcase of survival girl
	if not last_generation_special_flag: return
	if survival_girl_appeared: return
	if not actual_time < survival_girl_appear_time: return

	# survival girl enters
	survival_girl_appeared = true
	survival_girl_appears.emit()


# --
# public methods

func reset():

	# reset
	self.reset_time()

	# last generation special
	last_generation_special_flag = false
	survival_girl_appeared = false
	is_highlighting_count_down = false


func reset_time():
	
	# set time
	timer.start(starve_time)

	# reset state
	is_starved = false

	# highlight?
	if is_highlighting_count_down: self._highlight_starve_time_off()


func set_staving_time():

	# set time
	label_time.text = str(starve_time)
	if is_highlighting_count_down: self._highlight_starve_time_off()


func stop_counting():

	# simply stop
	timer.stop()


func last_generation_special():

	# make it special
	last_generation_special_flag = true


# --
# private methods

func _highlight_starve_time_on():

	# highlight
	is_highlighting_count_down = true
	label_time.set_label_settings(label_setting_time_highlight)


func _highlight_starve_time_off():

	# highlight
	is_highlighting_count_down = false
	label_time.set_label_settings(label_setting_time_normal)


# --
# signals

func _on_timer_timeout():

	# print
	print("starved")

	# stop timer
	timer.stop()

	# emit signal
	starved.emit()
