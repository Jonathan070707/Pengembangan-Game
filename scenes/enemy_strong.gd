extends CharacterBody2D

var health = 20

@onready var player = get_node("/root/Game/Player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@export var experience = 5
var exp_gem = preload("res://scenes/exprience_drop_1.tscn")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300
	move_and_slide()
	
func take_damage():
	health -= 1
	
	if health == 0:
		var new_gem = exp_gem.instantiate()
		new_gem.global_position = global_position
		new_gem.experience =  experience
		get_parent().add_child(new_gem)
		queue_free()
