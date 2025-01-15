extends RigidBody2D

@onready var pin_joint_2d: PinJoint2D = $PinJoint2D
var node_a : PhysicsBody2D

var ideal_distance :float
	

func fix_distance():
	var current_distance = (node_a.position - position).length()
	if current_distance > ideal_distance:
		print(current_distance)
		#node_a.position = (node_a.position - position).normalized()*ideal_distance
		apply_central_impulse((node_a.position - position)*0.5)

func assign_pin(node : PhysicsBody2D):
	pin_joint_2d.node_a = node.get_path()
	ideal_distance = (node.position - position).length()
	node_a = node
