extends RigidBody2D
class_name Player
#player components added by path
@onready var kick_ray: RayCast2D = $KickRay
@onready var pin_joint_2d: PinJoint2D = $PinJoint2D
@onready var grabber: Area2D = $Grabber
@onready var touch_timer: Timer = $TouchTimer
@onready var rays: Node2D = $Rays
@onready var wall_ray_r : RayCast2D = rays.get_child(0)
@onready var floor_ray : RayCast2D = rays.get_child(1)
@onready var wall_ray_l : RayCast2D = rays.get_child(2)
@onready var ceiling_ray : RayCast2D = rays.get_child(3)
@onready var muzzle: Marker2D = $Grabber/Muzzle
var FREEZE_AREA = preload("res://Scene/freeze_area.tscn")
var BULLET = preload("res://Scene/bullet.tscn")
@onready var state_machine: Node2D = $StateMachine
#external nodes added in the inspector
@export var tools: Node2D
@export var tool_2: VectorTool
@export var tool_3: VectorTool
@export var vent : Node2D
#editable variables
@export var slide_disconnect_speed : float = 30.0
#internally used globabl variables
var latched_object : Node2D
var grabbing := false
var latched := false
var GadgetLock = false
var gravity_lock = false


func _physics_process(_delta: float) -> void:
	grabber_logic()

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if state_machine.current_state.name == "PlayerZeroG":
		cust_move_and_slide()

func _on_grabber_body_entered(body: Node2D) -> void:
	if grabbing:
		pin_joint_2d.node_b = body.get_path()
		latched_object = body
		latched = true

func grabber_logic():
	if !latched:
		grabber.look_at(get_global_mouse_position())
	else:
		grabber.look_at(latched_object.get_global_transform().get_origin())
	if Input.is_action_just_pressed("grab"):
		grabbing = true
	if Input.is_action_just_released("grab"):
		grabbing = false
		if pin_joint_2d.node_b:
			pin_joint_2d.node_b = pin_joint_2d.node_a
	if !grabbing:
		latched = false
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("gadget") and !GadgetLock:
		get_parent().add_child(FREEZE_AREA.instantiate())
		GadgetLock = true
	if event.is_action("select") and GadgetLock:
		GadgetLock = false
	elif event.is_action("select"):
		shoot()

func cust_move_and_slide():
	if wall_ray_r.is_colliding():
		if absf(linear_velocity.x) < slide_disconnect_speed and absf(linear_velocity.y) > 10.0:
			var collision = move_and_collide(wall_ray_r.get_collision_point() - position)
			if collision:
				linear_velocity = linear_velocity.slide(collision.get_normal())
			linear_velocity.x = 0.0
			#print("wall R")
	if floor_ray.is_colliding():
		if absf(linear_velocity.y) < slide_disconnect_speed and absf(linear_velocity.x) > 10.0:
			#print(wall_ray_l.get_collision_point())
			var collision = move_and_collide(floor_ray.get_collision_point() - position)
			if collision:
				#print(collision.get_normal())
				linear_velocity = linear_velocity.slide(collision.get_normal())
			linear_velocity.y = 0.0
			#print("floor")
	if wall_ray_l.is_colliding():
		if linear_velocity.x < slide_disconnect_speed and absf(linear_velocity.y) > 10.0:
			#print(wall_ray_l.get_collision_point())
			var collision = move_and_collide(wall_ray_l.get_collision_point() - position)
			if collision:
				#print(collision.get_normal())
				linear_velocity = linear_velocity.slide(collision.get_normal())
			linear_velocity.x = 0.0
			#print("wall L")
	if ceiling_ray.is_colliding():
		if absf(linear_velocity.y) < slide_disconnect_speed and absf(linear_velocity.x) > 10.0:
			var collision = move_and_collide(ceiling_ray.get_collision_point() - position)
			if collision:
				linear_velocity = linear_velocity.slide(collision.get_normal())
			linear_velocity.y = 0.0
			#print("ceiling")

func _on_touch_timer_timeout() -> void:
	gravity_lock = false
	print("open")

func shoot():
	var b = BULLET.instantiate()
	owner.add_child(b)
	b.transform = muzzle.get_global_transform()
