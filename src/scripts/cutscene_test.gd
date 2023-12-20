extends Node2D

var selected_scene = 0

func _on_button_button_down():
	$cutscene.cutscene_play(selected_scene)


func _on_option_button_item_selected(index):
	selected_scene = index
	print(index)
