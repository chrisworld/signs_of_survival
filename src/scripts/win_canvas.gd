extends CanvasLayer

# exports
@export var win_canvas_on_time = 12.0

# refs
@onready var win_canvas_on_timer = $win_canvas_on_timer


# --
# public methods

func start_timer():
	win_canvas_on_timer.start(win_canvas_on_time)


func stop_timer():
	win_canvas_on_timer.stop()
