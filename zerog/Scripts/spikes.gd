extends Area2D
class_name Spikes

@export var damage := 25.0
@export var knockback := 50.0
var attack_position := Vector2.ZERO



func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		var h_box : HurtboxComponent = area
		var attack = Attack.new()
		attack.damage = damage
		attack.hit_position = global_position
		attack.knockback = knockback
		h_box.damage(attack)
		
