class_name Spawn_info
extends Resource
@export var time_start:int
@export var time_end:int
@export var enemy: PackedScene
@export var enemy_resource_path: String
@export var enemy_num:int
@export var enemy_spawn_delay:int
var spawn_delay_counter = 0
