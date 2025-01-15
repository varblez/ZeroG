extends CharacterBody2D

@onready var velocity_label: Label = $VelocityLabel
@onready var tool_2: VectorTool = $Tool2
@onready var tool_3: VectorTool = $Tool3
@onready var tool_4: VectorTool = $Tool4
@onready var tool_5: VectorTool = $Tool5
@onready var tool_6: VectorTool = $Tool6

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var touch_timer: Timer = $TouchTimer

@onready var rays: Node2D = $Rays

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const push_force = 100.0
var touch := false
var array_of_normals: Array[Vector2] = [Vector2.RIGHT,Vector2.UP]

func _ready() -> void:
	velocity += Vector2.DOWN*SPEED
	set_max_slides(100)

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	var mag = (get_global_mouse_position()-position).length()
	if rays.any_colisions():
		print("beep")
		var min_max = rays.get_min_max()
		tool_4.setvector(Vector2.RIGHT.rotated(min_max[0])*100)
		tool_5.setvector(Vector2.RIGHT.rotated(min_max[1])*100)
		print(min_max)
		touch = true
		touch_timer.start()
		tool_3.setvector(array_clamp(get_global_mouse_position()-position,rays.get_min_max())*mag)
		var t6 = get_global_mouse_position()-position
		tool_6.setvector(-t6)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
	
	#if get_slide_collision_count() > 0:
		#print(get_slide_collision_count())
		#touch = true
		#touch_timer.start()
		#array_of_normals.clear()
		#for i in get_slide_collision_count():
			#array_of_normals.append(get_slide_collision(i).get_normal())
	#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	##var direction := Input.get_axis("ui_left", "ui_right")
	##if direction:
	##	velocity.x = direction * SPEED
	##else:
	##	velocity.x = move_toward(velocity.x, 0, SPEED)
	#for i in get_slide_collision_count():
		#var collider = get_slide_collision(i)
		##print(collider.get_normal())
		#if collider.get_collider() is RigidBody2D:
			#collider.get_collider().apply_central_impulse(-collider.get_normal()*push_force)
			
	
	if Input.is_action_just_pressed("click") and touch:
		velocity += array_clamp(get_global_mouse_position()-position,rays.get_min_max())*mag
	tool_2.setvector(velocity*0.5)
	
	move_and_slide()
	
	#print(array_of_normals)

#func is_on_anything():
	#if is_on_floor() or is_on_wall() or is_on_ceiling():
		#return true
	#else:
		#return false

func cus_clamp(vector:Vector2, normal:Vector2):
	var normal_angle = normal.angle()
	var min_angle = normal_angle - PI/3
	var max_angle = normal_angle + PI/3
	var new_vector_angel = clamp(vector.angle(),min_angle,max_angle)
	return Vector2.RIGHT.rotated(new_vector_angel)

func clamp_from_array(vector:Vector2, normals:Array[Vector2]):
	var min_angle
	var max_angle
	for i in normals:
		if min_angle != null:
			min_angle = min(min_angle,i.angle()-(PI/3))
			max_angle = max(max_angle,i.angle()+(PI/3))
		else:
			min_angle = i.angle()-(PI/3)
			max_angle = i.angle()+(PI/3)
	#print(str(min_angle) + " , " + str(max_angle))
	#tool_4.setvector(Vector2.RIGHT.rotated(min_angle)*100)
	#tool_5.setvector(Vector2.RIGHT.rotated(max_angle)*100)
	var new_vector_angel = clamp(vector.angle(),min_angle,max_angle)
	#print(Vector2.RIGHT.rotated(new_vector_angel))
	return Vector2.RIGHT.rotated(new_vector_angel)
			

func array_clamp(vector: Vector2, min_max):
	var new_vector_angle = clamp(vector.angle(),min_max[0],min_max[1])
	return Vector2.RIGHT.rotated(new_vector_angle)

func _on_touch_timer_timeout() -> void:
	print("time")
	touch = false
