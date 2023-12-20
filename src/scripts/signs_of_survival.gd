extends Node2D

# exports
@export var is_start_scene_game = false

# refs
@onready var sign_world = $sign_world
@onready var title_canvas = $title_canvas
@onready var credits_canvas = $credits_canvas

# canvas flags
var is_title_canvas = false
var is_credits_canvas = false

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
	
	# escape
	if Input.is_action_just_pressed("escape"):

		if is_playing:

			# pause
			print("pause")
			get_tree().paused = true



# --
# public methods

func start_new_game():

	# reset sign world
	sign_world.reset_sign_world()


func title_canvas_on():

	# activate
	is_title_canvas = true

	# show
	title_canvas.show()


func title_canvas_off():

	# activate
	is_title_canvas = false

	# show
	title_canvas.hide()


func credits_canvas_on():

	# activate
	is_credits_canvas = true

	# show
	credits_canvas.show()


func credits_canvas_off():

	# activate
	is_credits_canvas = false

	# show
	credits_canvas.hide()


# --
# signals

func _on_title_canvas_start_game():

	# start new game
	self.start_new_game()
	is_playing = false
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
	
