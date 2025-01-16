extends RigidBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var player : RigidBody2D

var targetA : Vector2
var targetB : Vector2



func _physics_process(delta: float) -> void:
	position = targetA
	look_at(targetB)
	print((to_local(targetB) - targetA).length())
	collision_shape_2d.shape.b.x = (to_local(targetB) - targetA).length()

func set_a(a : Vector2):
	targetA = a
	
func set_b(b : Vector2):
	targetB = b
