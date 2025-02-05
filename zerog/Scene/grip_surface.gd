extends Area2D
class_name GripSurface
@onready var player_position: Node2D = $"Player Position"
@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D
@export var alignment_vector := Vector2.ZERO
@onready var tool_2: VectorTool = $Tool2


func _physics_process(delta: float) -> void:
	alignment_vector = (player_position.global_position - global_position).normalized()
	tool_2.global_rotation = Vector2.RIGHT.angle()
	tool_2.setvector(alignment_vector * 20)

func _on_body_entered(body: Node2D) -> void:
	print(alignment_vector)
	if body.has_method("touch_grabbable"):
		body.touch_grabbable(self, player_position, alignment_vector)
