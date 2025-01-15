extends RigidBody2D

var stuck := false
var pos  : Vector2
@onready var freeze_area: Area2D = $FreezeArea
@onready var sprite_2d: Sprite2D = $FreezeArea/Sprite2D

func _ready() -> void:
	pos = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	if !stuck:
		position = get_global_mouse_position()
		if Input.is_action_just_pressed("select"):
			sprite_2d.modulate = Color.WHITE
			pos = position
			stuck = true
			var  bodies  = freeze_area.get_overlapping_bodies()
			for body in bodies:
				if body is RigidBody2D:
					mass += body.mass
					body.position = to_local(body.global_position)
					body.rotation = body.global_rotation - global_rotation
					body.get_parent().remove_child(body)
					call_deferred("add_child", body)
					var body_loc = body.position
					for n in body.get_children(true):
						n.reparent(self,true)
						n.position = body_loc
					
					#body.freeze = true
	#else:
		#position = pos
	
	
