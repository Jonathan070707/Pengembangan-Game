extends AudioStreamPlayer

const bg_music = preload("res://assets/Audio/bgmSound.mp3")

func _play_music(music: AudioStream, volume = 0.0):
	stream = music
	volume_db = volume
	play()
	
func _play_bg_music():
	_play_music(bg_music)
