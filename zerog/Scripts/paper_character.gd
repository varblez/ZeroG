extends Node2D

@onready var head_target: Marker2D = $"IKTargets/Head Target"
@onready var head: Polygon2D = $Polygons/Head
@onready var jaw: Polygon2D = $Polygons/Jaw
@onready var head_flip: Polygon2D = $"Polygons/Head Flip"
@onready var jaw_flip: Polygon2D = $"Polygons/Jaw Flip"
@onready var arm_r_target: Marker2D = $"IKTargets/ArmR Target"
@onready var arm_l_target: Marker2D = $"IKTargets/ArmL Target"
@onready var arm_l_end: Marker2D = $"Skeleton2D/Hips/Torso/ArmL/ForeArmL/ArmL End"

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	head_target.global_position = get_global_mouse_position()
	#arm_r_target.global_position = get_global_mouse_position()
	if head_target.position.x < 0:
		#scale.x = -scale.x
		head.hide()
		jaw.hide()
		head_flip.show()
		jaw_flip.show()
	else:
		head.show()
		jaw.show()
		head_flip.hide()
		jaw_flip.hide()

func set_animation(animation : String):
	animation_player.play(animation)

func get_left_hand_pos() -> Vector2:
	return arm_l_end.position

func reset_targets():
	arm_r_target.position = Vector2(12.0,-32.5)
	arm_l_target.position = Vector2(132.0,-72.5)
