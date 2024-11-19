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
	stronger_enemy_active = false
	game_duration_timer = 600  # 10 menit
	# Hentikan semua timer jika masih aktif
	if stronger_enemy_timer.is_stopped() == false:
		stronger_enemy_timer.stop()



var stronger_enemy_timer: Timer  # Timer untuk memunculkan musuh kuat
# Timer for game duration (10 minutes)
var game_duration_timer = 600
var time = 0
# References to nodes

@onready var spawn_point = %PathFollow2D  # Assuming spawn point reference
@onready var BGM = %BgmSound
@onready var GameOver = %GameOverSfx

# Stronger enemy variables
var stronger_enemy_delay = 15  # Seconds after which stronger enemies start spawning
var stronger_enemy_duration = 45 # Seconds for which stronger enemies spawn (can be adjusted)
var stronger_enemy_active = false



func _ready() -> void:
	if player:
		connect("changetime", Callable(player, "change_time"))
	else:
		push_error("Player tidak ditemukan! Pastikan grup 'player' sudah ada.")
	
	# Mulai timer untuk musuh biasa
	$Timer.start()
	BGM.play()


# Inisialisasi timer untuk musuh bos
	stronger_enemy_timer = Timer.new()
	add_child(stronger_enemy_timer)
	stronger_enemy_timer.wait_time = 30  # Setel waktu tunggu berapa detik
	stronger_enemy_timer.one_shot = false  # Timer hanya berjalan sekali
	# Hubungkan sinyal timeout ke fungsi spawn_stronger_enemy menggunakan Callable
	var spawn_callable = Callable(self, "spawn_stronger_enemy")
	stronger_enemy_timer.timeout.connect(spawn_callable)
	stronger_enemy_timer.start()
	
	set_process(true)  # Mengaktifkan fungsi _process untuk mengurangi waktu permainan

func _process(delta: float) -> void:
	# Kurangi durasi permainan
	game_duration_timer -= delta
	
	
	# Mulai memunculkan musuh kuat pada detik ke-15 hingga menit pertama
	var elapsed_time = 600 - game_duration_timer
	if elapsed_time >= 15 and elapsed_time <= 60:
		if not stronger_enemy_active:
			stronger_enemy_active = true
			stronger_enemy_timer.start()  # Mulai timer untuk musuh kuat
	elif elapsed_time > 60 and stronger_enemy_active:
		stronger_enemy_active = false
		stronger_enemy_timer.stop()  # Hentikan timer untuk musuh kuat


	if game_duration_timer <= 0:
		end_game()


func spawn_mob():
	var new_enemy = preload("res://scenes/enemy.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_enemy.global_position = %PathFollow2D.global_position
	add_child(new_enemy)

func spawn_stronger_enemy():
	var stronger_enemy_scene = preload("res://scenes/enemy_strong.tscn").instantiate()
	stronger_enemy_scene.global_position = Vector2(randf_range(100, 500), randf_range(100, 500))  # Atur posisi acak atau sesuai kebutuhan
	add_child(stronger_enemy_scene)

func _on_timer_timeout() -> void:
	time += 1

	spawn_mob()  # Panggil musuh biasa
	emit_signal("changetime",time)
func _on_stronger_enemy_timer_timeout() -> void:
	spawn_stronger_enemy()  # Panggil musuh kuat ketika timer selesai

#GameOverView
func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	reset_game_state()
	GameOver.play()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	

#TimeOutView
func end_game() -> void:
	reset_game_state()
	%TimeOut.visible = true
	BGM.stop() # Berhentikan BGM saat permainan berakhir
	GameOver.play()
	#$SoundGameOver.start() > masih error
	get_tree().paused = false
	await BGM
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
func _on_sound_game_over_timeout() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

#Pause
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		game_paused = !game_paused
