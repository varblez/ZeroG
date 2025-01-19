extends State
class_name PlayerGravity

@export var player : Player
@export var SPEED = 1500.0
@export var move_speed_max = 120.0
@export var JUMP_VELOCITY = 9000.0
var soready = false

func enter():
	SignalBus._flip_gravity.emit(true)
	player.tools.hide()
	

func exit():
	player.floor_ray.set_collision_mask_value(3,false)

func physics_update(_delta : float):
	if Input.is_action_pressed("right") and player.linear_velocity.x < move_speed_max:
		player.apply_central_impulse(Vector2.RIGHT*SPEED)
	if Input.is_action_pressed("left") and player.linear_velocity.x > -move_speed_max:
		player.apply_central_impulse(Vector2.LEFT*SPEED)
	if Input.is_action_just_pressed("ui_accept") and player.floor_ray.is_colliding():
		player.apply_central_impulse(Vector2.UP*JUMP_VELOCITY)
	
	if Input.is_action_just_pressed("gravity") and not player.gravity_lock:
		player.gravity_lock = true
		player.touch_timer.start()
		Transitioned.emit(self,"PlayerZeroG")
