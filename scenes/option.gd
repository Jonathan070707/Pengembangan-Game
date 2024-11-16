extends Control

func _on_volume_pressed() -> void:
	pass # Replace with function body.

func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
