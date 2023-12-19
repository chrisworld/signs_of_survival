# --
# sign

extends RigidBody2D

# signal
signal sign_falls

# max num of clicks
@export var max_num_clicks = 5

# refs
@onready var sign_anim = $sign_anim

# num click
var num_clicks = 0

# disable clicks
var disable_clicks_flag = false

# frames
var num_frames = 0
var actual_frame = 0

# modulator
var next_frame_from_clicks_mod = 0


func _ready():

	# get num frames
	num_frames = sign_anim.sprite_frames.get_frame_count("sign_anim_sprites")

	# modulator (for clicking -> sprite update)
	next_frame_from_clicks_mod = floori(max_num_clicks / (num_frames - 1))
	if not next_frame_from_clicks_mod: next_frame_from_clicks_mod = 1

	# state reset
	self._reset_state()
	

# --
# public methods

func get_num_clicks():
	return num_clicks


func reset_to_position(new_position):

	# reset state
	self._reset_state()

	# position
	self.position = new_position


# --
# private methods

func _reset_state():

	# freeze object
	self.freeze = true

	# reset clicks
	num_clicks = 0

	# set frame
	actual_frame = 0
	sign_anim.frame = actual_frame

	# enable clicks again
	disable_clicks_flag = false


func _max_number_of_clicks_reached():
	
	# free object
	self.freeze = false
	
	# emit signal
	sign_falls.emit()
	
	# no clicks
	disable_clicks_flag = true

	# actual frame
	actual_frame = num_frames - 1

	# last frame
	sign_anim.frame = actual_frame
	
	# add a little impulse
	self.apply_torque_impulse(-0.3)
	

func _on_sign_area_input_event(_viewport, event, _shape_idx):
	
	# no clicks if disabled
	if disable_clicks_flag: return
	
	# detect mouse click
	if event is InputEventMouseButton:
	
		# cases to leave
		if not event.button_index == 1: return
		if not event.pressed: return
		if event.is_echo(): return
		
		# add counts
		num_clicks += 1
				
		# compare
		if num_clicks >= max_num_clicks:
			self._max_number_of_clicks_reached()
		
		# modulator
		if num_clicks % next_frame_from_clicks_mod: return
		
		# not last frame (sign is halfed)
		if actual_frame >= (num_frames - 2): return

		# next frame
		actual_frame += 1
		
		# set frame
		sign_anim.frame = actual_frame
