extends CharacterBody2D

signal health_depleted

@onready var player = get_node("/root/Game/Player")
@onready var sprite = $P_Sprite
var move_speed = 500
#HEALTH
var max_health = 10
var health = max_health

#EXP
var experience = 0
var exprience_level = 1
var collected_experience = 0

 #GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var label_level = get_node("%Label_level")


func _ready() -> void:
	set_expbar(experience, calculate_experiencecap ())
	
@onready var  P_Sprite= get_node("/root/Game/Player/P_Sprite")

func _physics_process(delta: float) -> void:
	var dir_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var dir_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var move = Vector2(dir_x,dir_y)
	velocity = move.normalized()*move_speed
	if dir_x > 0:
		P_Sprite.flip_h = false
	elif dir_x < 0:
		P_Sprite.flip_h = true
	move_and_slide()
	
	const HIT_DAMAAGE = 2
	var overlapping_enemy = %Hitbox.get_overlapping_bodies()
	if overlapping_enemy.size() > 0 :
		health -= HIT_DAMAAGE * overlapping_enemy.size() * delta
		%ProgressBar.max_value = max_health
		%ProgressBar.value = health 
		if health <= 0:
			health_depleted.emit()

func addAttack1():
	const ATTACK1 = preload("res://scenes/attack_1.tscn")
	var new_attack1 = ATTACK1.instantiate()
	add_child(new_attack1)  # Tambahkan sebagai child dari karakter
	new_attack1.position = Vector2.ZERO

func _on_grap_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target =  self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"): 
		var exp_collected =  area.collect()
		calculate_experience(exp_collected)
		
func calculate_experience(exp_collected):
	var exp_required = calculate_experiencecap()
	collected_experience += exp_collected 
	if experience + collected_experience >= exp_required: #level up
		collected_experience -= exp_required-experience
		exprience_level += 1
		label_level.text = str("Level: ", exprience_level)
		experience = 0 
		exp_required = calculate_experiencecap()
		calculate_experience(0)
		addAttack1()
	else:
		experience += collected_experience
		collected_experience = 0
	
	set_expbar(experience, exp_required)
	
func calculate_experiencecap():
	var exp_cap = exprience_level
	if exprience_level < 20:
		exp_cap = exprience_level * 5
	elif exprience_level < 40:
		exp_cap = 95 + (exprience_level-19)*8
	else:
		exp_cap = 255  + (exprience_level-39)*12
	
	return exp_cap

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value
	
