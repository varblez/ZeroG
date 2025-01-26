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
@onready var pain_partical: CPUParticles2D = $PainPartical
@onready var paper_character: Node2D = $PaperCharacter
#external nodes added in the inspector
@export var tools: Node2D
@export var tool_2: VectorTool
@export var tool_3: VectorTool
@export var vent : Node2D
@export var health : HealthComponent
#editable variables
@export var slide_disconnect_speed : float = 30.0
#internally used globabl variables
var latched_object : Node2D
var grabbing := false
var latched := false
var GadgetLock = false
var gravity_lock = false
var buffered_knockback : Vector2

func _physics_process(delta: float) -> void:
	#if state_machine.current_state.name == "PlayerZeroG":
		#look_at(global_position + linear_velocity)
	grabber_logic()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if grabbing:
		if(state.get_contact_count() >= 1):
			print("collision touch")
			if state.get_contact_collider_object(0).is_in_group("Grab"):
				paper_character.set_animation("Grab")
				rotation = state.get_contact_local_normal(0).angle()
				pin_joint_2d.node_b = state.get_contact_collider_object(0).get_path()
				latched_object = state.get_contact_collider_object(0)
				latched = true
		##if its a solid object
		#if state.get_contact_collider_object(0) is not RigidBody2D:
			#var normal = state.get_contact_local_normal(0)
			#linear_velocity = linear_velocity.reflect(normal)
			#tool_4.setfromvector(to_local(state.get_contact_collider_position(0)))
			#tool_4.setvector(normal * 30)
			#if absf(linear_velocity.project(normal).length()) < 10.0:
				#linear_velocity = linear_velocity.slide(normal)
				#print("1 velocity.project normal lengeth: ", linear_velocity.project(normal).length())
			#else:
				#linear_velocity = linear_velocity.bounce(normal)
			#elif linear_velocity.project(normal).length() > 20.0:
				#print(state.get_contact_impulse(0))
				#linear_velocity = linear_velocity.bounce(normal)
			

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
		paper_character.set_animation("Floating")
		shoot()

func cust_move_and_slide():
	if wall_ray_r.is_colliding():
		if absf(linear_velocity.x) < slide_disconnect_speed and absf(linear_velocity.y) > 10.0:
			var collision = move_and_collide(wall_ray_r.get_collision_point() - position)
			if collision:
				linear_velocity = linear_velocity.slide(collision.get_normal())
			linear_velocity.x = 0.0
			#print("wall R")
		#elif absf(linear_velocity.x) > slide_disconnect_speed:
			#var collision = move_and_collide(wall_ray_r.get_collision_point() - position)
			#if collision:
				#linear_velocity = linear_velocity.bounce(collision.get_normal())
	if floor_ray.is_colliding():
		if absf(linear_velocity.y) < slide_disconnect_speed and absf(linear_velocity.x) > 10.0:
			#print(wall_ray_l.get_collision_point())
			var collision = move_and_collide(floor_ray.get_collision_point() - position)
			if collision:
				#print(linear_velocity)
				linear_velocity = linear_velocity.slide(collision.get_normal())
				#print(linear_velocity)
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

func on_die():
	get_tree().reload_current_scene()

func _on_hurtbox_component_hit(attack: Attack) -> void:
	var knockback_vec = (global_position - attack.hit_position).normalized()
	#apply_central_impulse(knockback_vec*200)
	set_deferred("sleeping", true)
	set_deferred("freeze", true)
	buffered_knockback = knockback_vec*1000
	pain_partical.emitting = true
	health.damage(attack)

func _on_pain_partical_finished() -> void:
	freeze = false
	apply_central_impulse(buffered_knockback)

func _on_touch_detection_body_entered(body: Node2D) -> void:
	pass
