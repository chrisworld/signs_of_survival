extends Node2D

# signals
signal she_rescues_you
signal rescuing_anim_done

# refs
@onready var sprites = $sprites 
@onready var blink_timer = $blink_timer
@onready var blink_duration_timer = $blink_duration_timer

# vars
var she_rescues_you_flag = false

# const blink time
const blink_time_min = 1.0
const blink_time_var = 2.0
const blink_duration_min = 0.2
const blink_duration_var = 0.5


func _ready():

	# hide her
	self.hide()
	sprites.frame = 0
	blink_timer.stop()


# --
# public methods

func reset():
	self._ready()
	

func make_her_visible():
	
	# show her
	self.show()
	
	# start timer
	blink_timer.start(blink_time_min)


# --
# signals

func _on_survival_girl_area_input_event(_viewport, event, _shape_idx):

	# is she rescuing you
	if she_rescues_you_flag: return

	# detect mouse click
	if event is InputEventMouseButton:
	
		# cases to leave
		if not event.button_index == MOUSE_BUTTON_LEFT: return
		if not event.pressed: return
		if event.is_echo(): return
		
		# successful click
		she_rescues_you_flag = true
		she_rescues_you.emit()
		print("survival girl rescues you;)")

		# start anim?
		rescuing_anim_done.emit()


func _on_blink_timer_timeout():

	# new blink time
	var new_blink_time = blink_time_min + randf() * blink_time_var
	var new_blink_duration_time = blink_duration_min + randf() * blink_duration_var

	# start new blink timer
	blink_timer.start(new_blink_time)

	# set duration of blinking
	blink_duration_timer.start(new_blink_duration_time)

	# change to blinking anim
	sprites.frame = 1


func _on_blink_duration_timer_timeout():

	# change to sitting anim
	sprites.frame = 0
