extends Label

@onready var player: RigidBody2D = $"../Player"


@export var step = 0.01
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = get_global_mouse_position()
	text = str(str(snapped(get_global_mouse_position().x,step)) + " , " + str(snapped(get_global_mouse_position().y,step)))
