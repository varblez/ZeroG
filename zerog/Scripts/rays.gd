extends Node2D

@onready var ray_right: RayCast2D = $RayRight
@onready var ray_right_down: RayCast2D = $RayRightDown
@onready var ray_down: RayCast2D = $RayDown
@onready var ray_down_left: RayCast2D = $RayDownLeft
@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_left_up: RayCast2D = $RayLeftUp
@onready var ray_up: RayCast2D = $RayUp
@onready var ray_up_right: RayCast2D = $RayUpRight

var normal_array : Array = [null,null,null,null,null,null,null,null]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_right.is_colliding():
		normal_array[0] = ray_right.get_collision_normal()
	else:
		normal_array[0] = null
	if ray_right_down.is_colliding():
		normal_array[1] = ray_right_down.get_collision_normal()
	else:
		normal_array[1] = null
	if ray_down.is_colliding():
		normal_array[2] = ray_down.get_collision_normal()
	else:
		normal_array[2] = null
	if ray_down_left.is_colliding():
		normal_array[3] = ray_down_left.get_collision_normal()
	else:
		normal_array[3] = null
	if ray_left.is_colliding():
		normal_array[4] = ray_left.get_collision_normal()
	else:
		normal_array[4] = null
	if ray_left_up.is_colliding():
		normal_array[5] = ray_left_up.get_collision_normal()
	else:
		normal_array[5] = null
	if ray_up.is_colliding():
		normal_array[6] = ray_up.get_collision_normal()
	else:
		normal_array[6] = null
	if ray_up_right.is_colliding():
		normal_array[7] = ray_up.get_collision_normal()
	else:
		normal_array[7] = null
		
func any_colisions():
	if normal_array.count(null) == 8:
		return false
	else:
		return true
		
func get_min_max():
	var active_normals: Array = get_active_col_normals()
	var min_angle = 100.0
	var max_angle = -100.0
	if any_colisions():
		for i in active_normals.size():
			if active_normals[i]:
				min_angle = min(min_angle,active_normals[i].angle()-PI/3)
				max_angle = max(max_angle,active_normals[i].angle()+PI/3)
		return [min_angle,max_angle]

func get_active_col_normals():
	var active_normals: Array = []
	for i in normal_array:
		if i:
			active_normals.append(i)
	return active_normals
