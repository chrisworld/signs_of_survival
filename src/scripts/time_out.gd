extends Node2D

signal starved

# refs
@onready var timer = $Timer
@onready var label_time = $canvas/label_starve/label_starve_time

@export var starve_time = 60


func _ready():
	timer.start(starve_time)


func _process(_delta):
	label_time.text = str(int(timer.get_time_left()))


func _on_timer_timeout():
	print("time out, you died")
	timer.stop()
	starved.emit()
