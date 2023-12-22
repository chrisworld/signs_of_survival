extends Timer

# signals
signal starved
signal survival_girl_appears
signal critical_starve_time

# exports
@export var starve_time = 30.0
@export var survival_girl_appear_time = 10.0

# refs
#@onready var sign_world_canvas = $sign_world_canvas

# starved
var is_starved = false

# last generation special
var last_generation_special_flag = false
var survival_girl_appeared = false

# actual time
var actual_time


func _ready():

	# actual time
	actual_time = starve_time

	# reset
	self.reset()


func _process(_delta):

	# do not process this
	if is_starved: return
	if self.is_stopped(): return

	# update actual time
	actual_time = self.get_time_left()

	# specialcase of survival girl
	if not last_generation_special_flag: return
	if survival_girl_appeared: return
	if not actual_time < survival_girl_appear_time: return

	# survival girl enters
	print("timer survival girl")
	survival_girl_appeared = true
	survival_girl_appears.emit()


# --
# public methods

func start_timer_from_new():

	# set actual time
	self.start(starve_time)
	actual_time = starve_time


func reset():

	# reset
	self.reset_time()

	# last generation special
	last_generation_special_flag = false
	survival_girl_appeared = false


func reset_time():
	
	# reset state
	actual_time = starve_time


func stop_counting():

	# simply stop
	self.stop()


func last_generation_special():

	# make it special
	last_generation_special_flag = true


# --
# getter

func get_actual_starving_time(): return actual_time
func get_max_starving_time(): return starve_time

# --
# signals

func _on_timeout():

	# print
	print("starved!")

	# stop timer
	self.stop()

	# emit signal
	starved.emit()
