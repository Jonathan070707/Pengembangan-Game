extends Node2D

class_name Game

@onready var player = get_node("/root/Game/Player")

#Pause
signal toggle_name_paused(is_paused : bool) #signal for pause
signal changetime(time)

var game_paused : bool = false:
	get:
		return game_paused 
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_name_paused", game_paused)

#restart
func reset_game_state() -> void:
	# Reset semua variabel game
	game_paused = false
	game_duration_timer = 600
	# Hentikan semua timer jika masih aktif
	time = 0  # Reset waktu ke 0
	$Timer.stop()
	%End.visible = false
	%GameOver.visible = false
	%GameOverSfx.stop()
# Timer for game duration (10 minutes)
var game_duration_timer = 600
var time = 0
# References to nodes

@onready var spawn_point = %PathFollow2D  # Assuming spawn point reference
@onready var GameOver = %GameOverSfx




func _ready() -> void:
	reset_game_state()
	if player:
		connect("changetime", Callable(player, "change_time"))
	else:
		push_error("Player tidak ditemukan! Pastikan grup 'player' sudah ada.")
	# Mulai timer untuk musuh biasa
	$Timer.start()
	set_process(true)  # Mengaktifkan fungsi _process untuk mengurangi waktu permainan

func _process(delta: float) -> void:
	# Kurangi durasi permainan
	game_duration_timer -= delta
	
	if game_duration_timer <= 0:
		end_game()


func _on_timer_timeout() -> void:
	time += 1
	emit_signal("changetime",time)

#GameOverView
func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	GameOver.play()
	$SoundGameOver.start()
#TimeOutView
func end_game() -> void:
	%End.visible = true
	GameOver.play()
	$SoundGameOver.start()
	
	
func _on_sound_game_over_timeout() -> void:
	get_tree().paused = true

#Pause
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		game_paused = !game_paused
