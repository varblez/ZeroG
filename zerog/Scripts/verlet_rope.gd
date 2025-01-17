extends Node2D

@onready var line_2d: Line2D = $Line2D
@export var player : RigidBody2D
const CB_LINKS = preload("res://Scene/cb_links.tscn")
var ropeSegmentsCur : Array[Vector2]
var ropeSegmentsPrev : Array[Vector2]
var ropeColliders : Array[CharacterBody2D]
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
		ropeColliders.append(CB_LINKS.instantiate())
		self.add_child(ropeColliders[i])
		ropeColliders[i].position = ropeSegmentsCur[i]
		ropeColliders[i].set_target(ropeSegmentsCur[i])
		ropeStartPoint.y += ropeSegLen

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var r_gravity = Vector2.DOWN* 0 #25.0
	for i in numSegs:
		var velocity = ropeSegmentsCur[i] - ropeSegmentsPrev[i]
		ropeSegmentsPrev[i] = ropeSegmentsCur[i]
		ropeSegmentsCur[i] += velocity
		ropeSegmentsCur[i] += r_gravity*delta
		ropeColliders[i].set_target(ropeSegmentsCur[i])
	
	for i in 50:
		ApplyConstraints()
	SyncRope()

func ApplyConstraints():
	#ropeSegmentsCur[-1] = to_local(player.position)
	##attach start to the origin point of the scene
	ropeSegmentsCur[0] = Vector2.ZERO
	##loop preventing neighboring segments from getting too far apart
	for i in numSegs-1:
		##save working segments so we dont override till were done
		var firstSeg = ropeSegmentsCur[i]
		var secSeg = ropeSegmentsCur[i+1]
		##how far the segments are apart
		var dist = (firstSeg - secSeg).length()
		##difference with desired length
		var error = abs(dist-ropeSegLen)
		##find direction to move in
		var changeDir = Vector2.ZERO
		if dist > ropeSegLen:
			changeDir = (firstSeg - secSeg).normalized()
		elif dist < ropeSegLen:
			changeDir = (secSeg - firstSeg).normalized()
		##how far we need to move the segments total
		var changeAmount = changeDir * error
		##if not anchor point move both points towards eachother
		if i != 0:
			##move first segment half the distance needed and save it
			firstSeg -= changeAmount*0.5
			ropeSegmentsCur[i] = firstSeg
			##move firs segment half the distance needed and save it
			secSeg += changeAmount * 0.5
			ropeSegmentsCur[i+1] = secSeg
		##if first segment only move second segment
		else:
			secSeg += changeAmount
			ropeSegmentsCur[i+1] = secSeg
	for i in numSegs:
		if (ropeColliders[i].position - ropeSegmentsCur[i]).length() > 1.0:
			ropeSegmentsCur[i] = ropeColliders[i].position
			#ropeSegmentsPrev[i] = ropeColliders[i].position

func SyncRope():
	for i in numSegs:
		line_2d.set_point_position(i, ropeSegmentsCur[i])
		
	
