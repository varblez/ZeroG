extends State
class_name EnemyIdle

var target : Player
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var enemy: CharacterBody2D = $"../.."


func enter():
	target = enemy.target
	animated_sprite_2d.play("Passive")

func physics_update(_delta : float):
	if (target.position - enemy.position).length() < 100.0:
		Transitioned.emit(self,"EnemyFollow")
