extends Node2D

# exports
@export var is_start_scene_game = false

# refs
@onready var sign_world = $sign_world
@onready var title_canvas = $title_canvas
@onready var credits_canvas = $credits_canvas

# playing flag
var is_playing = false


func _ready():
	
	# set canvas
	if is_start_scene_game: title_canvas_off()
	else: title_canvas_on()
	credits_canvas_off()

	# is playing
	is_playing = false


func _process(_delta):

	# leave cases
	if title_canvas.visible: return
	if credits_canvas.visible: return
	if sign_world.is_cutscene_playing(): return

	# escape
	if Input.is_action_just_pressed("escape"):

			# pause
			if get_tree().paused: return

			# pause game
			self.pause_game()


# --
# public methods

func start_new_game():

	# reset sign world
	sign_world.reset_sign_world()

	# play
	is_playing = true


func pause_game():

	# must be in playing to pause
	if not is_playing: return

	print("pause")
	get_tree().paused = true


func unpause_game():

	print("unpause")
	get_tree().paused = false


func title_canvas_on():

	# activate
	is_playing = false

	# show
	title_canvas.show()

	# pause
	sign_world.pause_world()


func title_canvas_off():

	# show
	title_canvas.hide()


func credits_canvas_on():

	# activate
	is_playing = false

	# show
	credits_canvas.show()

	# pause
	sign_world.pause_world()


func credits_canvas_off():

	# show
	credits_canvas.hide()


# --
# signals

func _on_title_canvas_start_game():

	# start new game
	self.start_new_game()
	get_tree().paused = false

	# canvas off
	title_canvas_off()


func _on_title_canvas_credits():
	credits_canvas_on()
	title_canvas_off()


func _on_title_canvas_end_game():
	get_tree().quit()


func _on_credits_canvas_end_credits():
	title_canvas_on()
	credits_canvas_off()
	

func _on_sign_world_loose_cutscene_full_dark():
	credits_canvas_off()
	title_canvas_on()


func _on_sign_world_win_cutscene_full_dark():
	title_canvas_off()
	credits_canvas_on()


func _on_pause_canvas_go_to_title():
	title_canvas_on()
