extends State
class_name  PlayerZeroG



@export var push_force = 100.0


func enter():
	print("huh")
	SignalBus._flip_gravity.emit(false)
	player.tools.show()
	player.tools.visible = true
	

func exit():
	player.floor_ray.set_collision_mask_value(3,true)

func physics_update(delta: float):
	player.look_at(player.global_position + player.linear_velocity)
	point_and_tools()
	if Input.is_action_just_pressed("click") and player.kick_ray.is_colliding():
		kick_off()

	if Input.is_action_pressed("vent") and player.vent:
		player.apply_central_force((player.vent.position-player.position)*10)
	
	if Input.is_action_just_pressed("gravity") and not player.gravity_lock:
		player.gravity_lock = true
		player.gravity_timer.start()
		Transitioned.emit(self,"PlayerGravity")
		

#func forces_update(state: PhysicsDirectBodyState2D):
	#if player.align_vec:
		#player.global_rotation = player.align_vec.angle()

func grab(grabbed_obj : GripSurface):
	Transitioned.emit(self,"PlayerGrip")

#func kick_off():
	##rotation = point_vec.angle() + PI/2
	#if player.latched_object:
		#print("here")
		#player.latched_object.remote_transform_2d = player.latched_object.remote_transform_2d
		#player.latched_object = null
		#player.latched = false
		#player.set_deferred("freeze",false)
	#if player.kick_ray.get_collider() is RigidBody2D:
		#player.kick_ray.get_collider().apply_central_impulse(-point_vec*kick_force)
	#player.paper_character.set_animation("Kick")
	#player.call_deferred("apply_central_impulse",point_vec*kick_force)
