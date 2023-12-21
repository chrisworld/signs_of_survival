extends Node2D

# signals
signal she_rescues_you
signal rescuing_anim_done

# vars
var she_rescues_you_flag = false


func _ready():
	self.hide()


# --
# public methods

func make_her_visible():
	self.show()


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
