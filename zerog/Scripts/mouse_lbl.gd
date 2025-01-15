extends Label

@onready var player: RigidBody2D = $"../Player"


@export var step = 0.01
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_global_mouse_position()
	var vector = get_global_mouse_position()-player.position
	text = str(snapped(vector.angle(),step))
