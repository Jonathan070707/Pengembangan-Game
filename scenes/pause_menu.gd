extends Control

@export var game : Game

func _ready() -> void:
	hide()
	game.connect("toggle_name_paused", _on_game_toggle_game_paused)

func _on_game_toggle_game_paused(is_paused : bool):
	if(is_paused):
		show()
	else:
		hide()

func _on_resume_button_pressed() -> void:
	game.game_paused = false

func _on_exit_to_main_menu_pressed() -> void:
	game.game_paused = false	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
