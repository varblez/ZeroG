extends Node
class_name State

@export var player :Player
@export var kick_force : = 50.0
@export var max_kick_force := 100.0
var point_vec : Vector2

signal Transitioned

func enter():
	pass

func exit():
	pass

func update(_delta : float):
	pass

func physics_update(_delta:float):
	pass

func forces_update(state: PhysicsDirectBodyState2D):
	pass

func grab(grabbed_obj : GripSurface):
	pass

##shared functions
func point_and_tools():
	
	
	point_vec = player.get_global_mouse_position() - player.position
	if point_vec.length() > max_kick_force:
		point_vec = point_vec.normalized()*max_kick_force

	player.tools.global_rotation = 0.0
	player.tool_2.setvector(player.linear_velocity)
	player.tool_3.setvector(point_vec)

	player.kick_ray.look_at(player.get_global_mouse_position())

func kick_off():
	#rotation = point_vec.angle() + PI/2
	if player.latched_object:
		print("here")
		player.latched_object.remote_transform_2d = player.latched_object.remote_transform_2d
		player.latched_object = null
		player.latched = false
		player.set_deferred("freeze",false)
	if player.kick_ray.get_collider() is RigidBody2D:
		player.kick_ray.get_collider().apply_central_impulse(-point_vec*kick_force)
	player.paper_character.set_animation("Kick")
	player.call_deferred("apply_central_impulse",point_vec*kick_force)
