extends CharacterBody2D

signal health_depleted

var max_health = 10
var health = max_health

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	
	const HIT_DAMAAGE = 2
	var overlapping_enemy = %Hitbox.get_overlapping_bodies()
	if overlapping_enemy.size() > 0 :
		health -= HIT_DAMAAGE * overlapping_enemy.size() * delta
		%ProgressBar.max_value = max_health
		%ProgressBar.value = health 
		if health <= 0:
			health_depleted.emit()
