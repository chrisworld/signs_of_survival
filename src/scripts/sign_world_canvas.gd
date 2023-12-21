extends CanvasLayer

# refs
@onready var label_watch_out = $label_watch_out
@onready var label_starved = $label_starved


func _ready():
	
	# hide
	self.hide()
	label_watch_out.hide()
	label_starved.hide()


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


func show_label_starved(): 

	# show
	self.show()
	label_starved.show()


func hide_label_starved(): 

	# hide
	self.hide()
	label_starved.hide()
