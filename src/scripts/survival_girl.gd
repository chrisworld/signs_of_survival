extends Node2D

# signals
signal she_rescues_you
signal rescuing_anim_done

@export var is_already_dying = false

# refs
@onready var sprites = $sprites 
@onready var sfx_girl_chuckle = $sfx_girl_chuckle
@onready var sfx_girl_voice = $sfx_girl_voice

# vars
var pos_sfx_girl_voice
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
	sfx_girl_voice.stop()
	sfx_girl_chuckle.stop()
	she_rescues_you_flag = false
	is_already_dying = false


func make_her_visible():
	
	# show her
	self.show()

	# look animation
	sprites.set_animation(anim_look)

	# play animation
	sprites.play()
	sfx_girl_voice.play()

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
		if is_already_dying: return
		# successful click
		she_rescues_you_flag = true
		sfx_girl_voice.stop()
		sfx_girl_chuckle.stop()
		she_rescues_you.emit()
		print("survival girl comes for rescue;)")

		# start anim?
		rescuing_anim_done.emit()


func _on_survival_girl_area_mouse_entered():
	sprites.set_animation(anim_smile)
	if sfx_girl_voice.playing:
		pos_sfx_girl_voice = sfx_girl_voice.get_playback_position()
		sfx_girl_voice.stop()
		sfx_girl_chuckle.play()
	

func _on_survival_girl_area_mouse_exited():
	sprites.set_animation(anim_look)
	if sfx_girl_chuckle.playing:
		sfx_girl_chuckle.stop()
		sfx_girl_voice.play(pos_sfx_girl_voice)
