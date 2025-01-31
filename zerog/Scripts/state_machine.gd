extends Node2D

@export var initial_state : State
var states : Dictionary = {}
var current_state : State
var grip_surface : GripSurface


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func remote_intigrate_forces(state: PhysicsDirectBodyState2D):
	if current_state:
		current_state.forces_update(state)

func on_grab(grab_obj : GripSurface):
	grip_surface = grab_obj
	if current_state:
		current_state.grab(grab_obj)

func on_child_transitioned(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	if new_state:
		current_state = new_state
		current_state.enter()
