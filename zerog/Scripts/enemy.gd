extends CharacterBody2D

@export var speed = 35
@export var push_force = 10
@export var target : Node2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var AI_On = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if AI_On:
		var dir  = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		velocity = dir * speed
		
		for i in get_slide_collision_count():
			var collider = get_slide_collision(i)
			if collider.get_collider() is RigidBody2D:
				collider.get_collider().apply_central_impulse(-collider.get_normal()*push_force)
		
		move_and_slide()


func _on_timer_timeout() -> void:
	navigation_agent_2d.target_position = target.global_position
