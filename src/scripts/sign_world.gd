extends Node2D

# refs
@onready var label_watch_out = $canvas/label_watch_out
@onready var sign_static_part = $sign_static_part
@onready var character = $character


func _on_sign_sign_falls():
	sign_static_part.visible = true
	label_watch_out.visible = true


func _on_time_out_starved():
	character.set_state_dying()
