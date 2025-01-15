extends Label

var physics_obj : PhysicsBody2D
var velocity : Vector2 = Vector2.ZERO
@export var snapping := 0.001

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	physics_obj = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if physics_obj is CharacterBody2D:
		velocity = physics_obj.velocity
	elif physics_obj is RigidBody2D:
		velocity = physics_obj.linear_velocity
	elif physics_obj is StaticBody2D:
		velocity = physics_obj.constant_linear_velocity
	
	text = str(snapped(velocity.x,snapping)) + "," + str(snapped(velocity.y,snapping))
		
