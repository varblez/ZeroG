extends CharacterBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var target : Vector2
signal collision_signal(colData : KinematicCollision2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if target:
		var collision = move_and_collide(velocity)
		if collision:
			collision_signal.emit(collision)
		velocity = target - position
		

func set_target(target : Vector2):
	self.target = target
