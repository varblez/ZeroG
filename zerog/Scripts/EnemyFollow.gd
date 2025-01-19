extends State
class_name EnemyFollow

@onready var enemy: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var navigation_agent_2d: NavigationAgent2D = $"../../NavigationAgent2D"

var target : Player
var nav_agent : NavigationAgent2D 
@export var speed = 35
@export var push_force = 100

func enter():
	target = enemy.target
	animated_sprite_2d.play("Active")

func physics_update(_delta: float):
	if enemy.AI_On:
		var dir = Vector2.ZERO
		if navigation_agent_2d:
			dir  = enemy.to_local(navigation_agent_2d.get_next_path_position()).normalized()
		enemy.velocity = dir * speed
		
		for i in enemy.get_slide_collision_count():
			var collider = enemy.get_slide_collision(i)
			if collider.get_collider() is RigidBody2D:
				collider.get_collider().apply_central_impulse(-collider.get_normal()*push_force)
		
		enemy.move_and_slide()
		
	if (target.position - enemy.position).length() > 100:
		Transitioned.emit(self,"EnemyIdle")
