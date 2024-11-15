extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_option_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/option.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
