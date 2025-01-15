extends RigidBody2D
#player components added by path
@onready var kick_ray: RayCast2D = $KickRay
@onready var pin_joint_2d: PinJoint2D = $PinJoint2D
@onready var grabber: Area2D = $Grabber
@onready var floor_ray: RayCast2D = $FloorRay
var FREEZE_AREA = preload("res://Scene/freeze_area.tscn")
#external nodes added in the inspector
@export var tools: Node2D
@export var tool_2: VectorTool
@export var tool_3: VectorTool
@export var vent : Node2D
#editable variables
@export var SPEED = 1500.0
@export var move_speed_max = 120.0
@export var JUMP_VELOCITY = 18000.0
@export var kick_force : = 50.0
@export var max_kick_force := 100.0
@export var push_force = 100.0
#internally used globabl variables
var latched_object : Node2D
var grabbing := false
var latched := false
var point_vec : Vector2
var GravityOn = false
var GadgetLock = false


func _physics_process(delta: float) -> void:
	#change gravity
	if Input.is_action_just_pressed("gravity"):
		SignalBus._flip_gravity.emit(!GravityOn)
		GravityOn = !GravityOn
		rotation = 0.0

	#make and limit point_vec
	point_vec = get_global_mouse_position()-position
	if point_vec.length() > max_kick_force:
		point_vec = point_vec.normalized()*max_kick_force

	#launch off
	if Input.is_action_just_pressed("click") and kick_ray.is_colliding():
		kick_off()

	##apply push force to physics objects bumped into
	#for i in get_slide_collision_count():
		#var collider = get_slide_collision(i)
		#if collider.get_collider() is RigidBody2D:
			#collider.get_collider().apply_central_impulse(-collider.get_normal()*push_force)
	#if GravityOn:
		#tools.visible = false
		## Add the gravity.
		#if not is_on_floor():
			#velocity += get_gravity() * delta
#
		## Handle jump.
		#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			#velocity.y = JUMP_VELOCITY
#
		## Get the input direction and handle the movement/deceleration.
		## As good practice, you should replace UI actions with custom gameplay actions.
		#var direction := Input.get_axis("left", "right")
		#if direction:
			#velocity.x = direction * SPEED
		#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	if GravityOn:
		gravity_controls()
	else:
		
		tool_2.setvector(linear_velocity*0.5)
		lock_rotation = false
		if Input.is_action_pressed("vent") and vent:
			apply_central_force((vent.position-position)*10)
	
	tools.visible = true
	tools.position = position
	tool_3.setvector(point_vec)

	kick_ray.look_at(get_global_mouse_position())

	grabber_logic()

	#move_and_slide()

func _on_grabber_body_entered(body: Node2D) -> void:
	if grabbing:
		pin_joint_2d.node_b = body.get_path()
		latched_object = body
		latched = true

func gravity_controls():
	lock_rotation = true
	if Input.is_action_pressed("right") and linear_velocity.x < move_speed_max:
		apply_central_impulse(Vector2.RIGHT*SPEED)
	if Input.is_action_pressed("left") and linear_velocity.x > -move_speed_max:
		apply_central_impulse(Vector2.LEFT*SPEED)
	if Input.is_action_just_pressed("ui_accept") and floor_ray.is_colliding():
		apply_central_impulse(Vector2.UP*JUMP_VELOCITY)

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

##add force in direction of mouse, handle unlatching, and launch rigidbodies away
func kick_off():
	apply_central_impulse(point_vec*kick_force)
	if pin_joint_2d.node_b and latched_object == kick_ray.get_collider():
		pin_joint_2d.node_b = pin_joint_2d.node_a
		latched = false
	if kick_ray.get_collider() is RigidBody2D:
		kick_ray.get_collider().apply_central_impulse(-point_vec*kick_force)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("gadget") and !GadgetLock:
		get_parent().add_child(FREEZE_AREA.instantiate())
		GadgetLock = true
	if event.is_action("select") and GadgetLock:
		GadgetLock = false
