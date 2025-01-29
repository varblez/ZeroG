extends State
class_name PlayerGrip

@onready var player: Player = $"."
var latched_obj

func enter():
	if player.latched_object:
		latched_obj = player.latched_object
		
func forces_update(state: PhysicsDirectBodyState2D):
	if latched_obj.alignment_vector:
		player.global_rotation = latched_obj.alignment_vector.angle()
