extends Node2D
class_name HealthComponent

var health : float
var max_health : float = 100.0

func _ready() -> void:
	health = max_health

func damage(attack : Attack):
	health -= attack.damage
	if health <= 0:
		if get_parent().has_method("on_die"):
			get_parent().on_die()
