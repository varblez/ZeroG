extends Node2D

@onready var line_2d: Line2D = $Line2D
@export var player : RigidBody2D
var RIGID_SEGMENT_TEST = preload("res://Scene/rigid_segment_test.tscn")
var ropeSegmentsCur : Array[Vector2]
var ropeSegmentsPrev : Array[Vector2]
var ropeSegLen := 3.0
var numSegs := 35
var inst


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ropeStartPoint = Vector2.ZERO
	for i in numSegs:
		ropeSegmentsCur.append(ropeStartPoint)
		ropeSegmentsPrev.append(ropeStartPoint)
		line_2d.add_point(ropeStartPoint)
		ropeStartPoint.y += ropeSegLen
	inst = RIGID_SEGMENT_TEST.instantiate()
	self.add_child(inst)
	inst.set_a(ropeSegmentsCur[0])
	inst.set_b(player.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#inst.set_a(ropeSegmentsCur[0])
	inst.set_b(player.position)
	var r_gravity = Vector2.DOWN* 0#25.0
	for i in numSegs:
		var velocity = ropeSegmentsCur[i] - ropeSegmentsPrev[i]
		ropeSegmentsPrev[i] = ropeSegmentsCur[i]
		ropeSegmentsCur[i] += velocity
		ropeSegmentsCur[i] += r_gravity*delta
	
	for i in 10:
		ApplyConstraints()
	SyncRope()

func ApplyConstraints():
	ropeSegmentsCur[-1] = to_local(player.position)
	ropeSegmentsCur[0] = Vector2.ZERO
	
	for i in numSegs-1:
		var firstSeg = ropeSegmentsCur[i]
		var secSeg = ropeSegmentsCur[i+1]
		var dist = (firstSeg - secSeg).length()
		var error = abs(dist-ropeSegLen)
		var changeDir = Vector2.ZERO
		if dist > ropeSegLen:
			changeDir = (firstSeg - secSeg).normalized()
		elif dist < ropeSegLen:
			changeDir = (secSeg - firstSeg).normalized()
		
		var changeAmount = changeDir * error
		if i != 0:
			firstSeg -= changeAmount*0.5
			ropeSegmentsCur[i] = firstSeg
			secSeg += changeAmount * 0.5
			ropeSegmentsCur[i+1] = secSeg
		else:
			secSeg += changeAmount
			ropeSegmentsCur[i+1] = secSeg

func SyncRope():
	for i in numSegs:
		line_2d.set_point_position(i, ropeSegmentsCur[i])
	
