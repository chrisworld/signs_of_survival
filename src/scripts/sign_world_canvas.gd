extends CanvasLayer

# refs
@onready var label_watch_out = $label_watch_out


func _ready():
	
	# hide
	self.hide()
	label_watch_out.hide()


# --
# public methods

func show_label_watch_out(): 

	# show
	self.show()
	label_watch_out.show()


func hide_label_watch_out(): 

	# hide
	self.hide()
	label_watch_out.hide()
