extends RigidBody2D
class_name Player
#player components added by path
@onready var kick_ray: RayCast2D = $KickRay
@onready var gravity_timer: Timer = $GravityTimer
@onready var rays: Node2D = $Rays
@onready var wall_ray_r : RayCast2D = rays.get_child(0)
@onready var floor_ray : RayCast2D = rays.get_child(1)
@onready var wall_ray_l : RayCast2D = rays.get_child(2)
@onready var ceiling_ray : RayCast2D = rays.get_child(3)
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
	state_machine.remote_intigrate_forces(state)
	if grabbing:
		if(state.get_contact_count() >= 1):
			pass
				

func grabber_logic():
	if Input.is_action_just_pressed("grab"):
		grabbing = true
	if Input.is_action_just_released("grab"):
		grabbing = false
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

func shoot():
	var b = BULLET.instantiate()
	owner.add_child(b)
	b.transform = paper_character.arm_l_end.get_global_transform()

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

func touch_grabbable(obj:GripSurface, mount:Node2D, align:Vector2):
	if grabbing:
		state_machine.on_grab(obj)
		print(obj.name)
		
		latched_object = obj
		
		
	


func _on_gravity_timer_timeout() -> void:
	gravity_lock = false
