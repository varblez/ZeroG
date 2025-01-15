extends Node2D

@onready var air_particle: CPUParticles2D = $AirParticle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("vent"):
		air_particle.emitting = true
	elif Input.is_action_just_released("vent"):
		air_particle.emitting = false
