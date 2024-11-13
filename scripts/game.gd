extends Node2D

# Timer untuk mengakhiri permainan setelah 10 menit (600 detik)
var game_duration_timer = 600
var stronger_enemy_timer: Timer  # Timer untuk memunculkan musuh kuat

func _ready() -> void:
	# Mulai timer untuk musuh biasa
	$Timer.start()
	# Buat timer untuk musuh kuat
	
	set_process(true)  # Mengaktifkan fungsi _process untuk mengurangi waktu permainan

func _process(delta: float) -> void:
	# Kurangi durasi permainan
	game_duration_timer -= delta
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
	spawn_mob()  # Panggil musuh biasa
	spawn_stronger_enemy()
func _on_stronger_enemy_timer_timeout() -> void:
	spawn_stronger_enemy()  # Panggil musuh kuat ketika timer selesai

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true

func end_game() -> void:
	%TimeOut.visible = true
	get_tree().paused = true
