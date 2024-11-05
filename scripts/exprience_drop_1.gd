extends Area2D

@export var experience = 1

var exp1 = preload("res://assets/sprites/enemyXpDrop.svg")
var exp2 = preload("res://assets/sprites/enemyXpDrop2.svg")

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var expCollectedSound = $expSoundCollected

func _ready():
	if experience < 5:
		return
	else:
		sprite.texture = exp2 

func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta
		
func collect():
	expCollectedSound.play()
	collision.call_deferred("set", "disable", true)
	sprite.visible = false
	return experience
	

func _on_exp_sound_collected_finished() -> void:
	queue_free()
