extends Node2D

# signals
signal she_rescues_you
signal rescuing_anim_done

# refs
@onready var sprites = $sprites 

# vars
var she_rescues_you_flag = false

# cons anim names
const anim_look = "look"
const anim_smile = "smile"


func _ready():

	# hide her
	self.hide()


# --
# public methods

func reset():
	self._ready()
	

func make_her_visible():
	
	# show her
	self.show()

	# look animation
	sprites.set_animation(anim_look)

	# play animation
	sprites.play()


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
		print("survival girl comes for rescue;)")

		# start anim?
		rescuing_anim_done.emit()


func _on_survival_girl_area_mouse_entered():
	sprites.set_animation(anim_smile)


func _on_survival_girl_area_mouse_exited():
	sprites.set_animation(anim_look)
