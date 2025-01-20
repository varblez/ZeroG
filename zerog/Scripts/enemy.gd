extends CharacterBody2D


@export var target : RigidBody2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_particle: CPUParticles2D = $DeathParticle
@export var health : HealthComponent
@onready var stun_timer: Timer = $StunTimer

@export var AI_On = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	navigation_agent_2d.target_position = target.global_position

func on_die():
	AI_On = false
	death_particle.emitting = true
	

func _on_death_particle_finished() -> void:
	queue_free()


func _on_hurtbox_component_hit(attack: Attack) -> void:
	if health:
		health.damage(attack)
	AI_On = false
	stun_timer.start()
	velocity = (global_position - attack.hit_position).normalized()*attack.knockback


func _on_stun_timer_timeout() -> void:
	AI_On = true
