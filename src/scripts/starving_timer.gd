extends Node2D

# signals
signal starved

# exports
@export var starve_time = 30

# refs
@onready var timer = $Timer
@onready var show_starved_timer = $show_starved_timer
@onready var label_time = $canvas/label_starve/label_starve_time
@onready var label_starved = $canvas/label_starved

# starved
var is_starved = false

# const
const show_starved_time = 2.0


func _ready():

	# reset
	self.reset_time()


func _process(_delta):

	# do not process this
	if is_starved: return
	if timer.is_stopped(): return

	# update time
	label_time.text = str(int(timer.get_time_left()))


# --
# public methods

func reset_time():
	
	# set time
	timer.start(starve_time)

	# reset state
	is_starved = false

	# hide label
	label_starved.visible = false


func set_staving_time():

	# set time
	label_time.text = str(starve_time)


func stop_counting():

	# simply stop
	timer.stop()


# --
# signals

func _on_timer_timeout():

	# print
	print("starved")

	# stop timer
	timer.stop()

	# emit signal
	starved.emit()

	# show message
	show_starved_timer.start(show_starved_time)

	# show label
	label_starved.visible = true


func _on_show_starved_timer_timeout():
	
	# hide label
	label_starved.visible = false
