extends Area2D
class_name GripSurface
@onready var player_position: Node2D = $"Player Position"
@export var alignment_vector := Vector2.ZERO

func _physics_process(delta: float) -> void:
	alignment_vector = (player_position.global_position - global_position).normalized()

func _on_body_entered(body: Node2D) -> void:
	print(alignment_vector)
	if body.has_method("touch_grabbable"):
		body.touch_grabbable(self, player_position, alignment_vector)
