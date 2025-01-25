extends State
class_name  PlayerZeroG

@export var player : Player

@export var kick_force : = 50.0
@export var max_kick_force := 100.0
@export var push_force = 100.0
var point_vec : Vector2
var soready := false

func enter():
	SignalBus._flip_gravity.emit(false)
	player.tools.show()

func exit():
	player.floor_ray.set_collision_mask_value(3,true)

func physics_update(delta: float):
	player.look_at(player.global_position + player.linear_velocity)
	point_vec = player.get_global_mouse_position() - player.position
	if point_vec.length() > max_kick_force:
		point_vec = point_vec.normalized()*max_kick_force
	
	if Input.is_action_just_pressed("click") and player.kick_ray.is_colliding():
		kick_off()
		
	player.tool_2.setvector(player.linear_velocity)
	player.tools.visible = true
	player.tools.position = player.position
	player.tool_3.setvector(point_vec)

	player.kick_ray.look_at(player.get_global_mouse_position())

	if Input.is_action_pressed("vent") and player.vent:
		player.apply_central_force((player.vent.position-player.position)*10)
	
	if Input.is_action_just_pressed("gravity") and not player.gravity_lock:
		player.gravity_lock = true
		player.touch_timer.start()
		Transitioned.emit(self,"PlayerGravity")


func kick_off():
	print(point_vec*kick_force)
	player.apply_central_impulse(point_vec*kick_force)
	#rotation = point_vec.angle() + PI/2
	if player.pin_joint_2d.node_b and player.latched_object == player.kick_ray.get_collider():
		player.pin_joint_2d.node_b = player.pin_joint_2d.node_a
		player.latched = false
	elif player.pin_joint_2d.node_b and player.latched_object.is_in_group("Static Grab"):
		player.pin_joint_2d.node_b = player.pin_joint_2d.node_a
		player.latched = false
	if player.kick_ray.get_collider() is RigidBody2D:
		player.kick_ray.get_collider().apply_central_impulse(-point_vec*kick_force)
