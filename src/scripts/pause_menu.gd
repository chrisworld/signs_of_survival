extends CanvasLayer

# signals
signal go_to_title

# awake var
var is_awake = false


func _ready():

	# set awake
	is_awake = false


func _process(_delta):

	# start timer
	if not is_awake:
		self.show()
		is_awake = true
		return

	# escape
	if Input.is_action_just_pressed("escape"):

		# disable menu
		self._disable_pause_menu()


# --
# private methods

func _disable_pause_menu():

	print("unpaused")
	self.hide()
	is_awake = false
	get_tree().paused = false
	

func _on_continue_pressed():
	self._disable_pause_menu()


func _on_end_pressed():
	go_to_title.emit()
	self._disable_pause_menu()
