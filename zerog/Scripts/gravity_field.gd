extends Area2D


func _ready() -> void:
	SignalBus.connect("_flip_gravity",flip_gravity)
	
func flip_gravity(switch: bool):
	if switch:
		gravity = 980
	else:
		gravity = 0
