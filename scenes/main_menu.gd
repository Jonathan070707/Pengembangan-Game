extends Control

@onready var option_menu = $OptionScene  # Menu opsi
@onready var allbutton = $MarginContainer
@onready var music = $BgmSound

func _ready() -> void:
	option_menu.visible = false

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_option_pressed() -> void:
	option_menu.visible = true  # Menampilkan opsi sebagai popup
	allbutton.visible = false
	# Menonaktifkan tombol agar tidak bisa diklik



func _on_quit_pressed() -> void:
	get_tree().quit()



func _on_option_scene_focus_entered() -> void:
	allbutton.visible = true
