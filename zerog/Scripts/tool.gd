@tool
extends Node2D
class_name VectorTool

@export var hideInGame: bool = true
@export var vector = Vector2(100, 100)
@export var color = Color(255, 0, 0)
@export var thickness: float = 1.0

var vectorFrom = Vector2(0, 0)

const arrowAngle: float = PI / 6.0
const arrowToVecRatio: float = 5.0

func setfromvector(newV: Vector2) -> void:
	vectorFrom = newV
	queue_redraw()    

func setvector(newV: Vector2) -> void:
	vector = newV
	queue_redraw()

func setcolor(newC: Color) -> void:
	color = newC
	queue_redraw()

func _draw() -> void:
	if (Engine.is_editor_hint or !hideInGame) and vector:
		var arrowLength: float = vector.length() / arrowToVecRatio

		draw_line(vectorFrom, vector, color, thickness)
		var lineEnd = ((arrowLength) / vector.length()) * vector
		draw_line(vector, vector - lineEnd.rotated(-arrowAngle)/2, color, thickness)
		draw_line(vector, vector - lineEnd.rotated(arrowAngle)/2, color, thickness)
