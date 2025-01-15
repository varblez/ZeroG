extends StaticBody2D
@onready var chain_anchor: StaticBody2D = $"."

var links : Array[PhysicsBody2D]

func _ready() -> void:
	#build links array
	for i in get_child_count():
		if get_child(i) is PhysicsBody2D:
			links.append(get_child(i))
			
	for i in links.size():
		if i == 0:
			if links[i].has_method("assign_pin"):
				links[i].assign_pin(chain_anchor)
		else:
			if links[i].has_method("assign_pin"):
				links[i].assign_pin(links[i-1])

func _physics_process(delta: float) -> void:
	for i in links.size():
		links[i].fix_distance()
