extends Area2D

@export var speed : float = 250.0
var attack : Attack

func _ready() -> void:
	attack = Attack.new()
	attack.damage = 20.0
	attack.hit_position = position
	attack.knockback = 10.0

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	

func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	if area is HurtboxComponent:
		var h_box : HurtboxComponent = area
		h_box.damage(attack)
	queue_free()



func _on_body_entered(body: Node2D) -> void:
	queue_free()
