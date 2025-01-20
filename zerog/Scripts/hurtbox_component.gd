extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent
signal hit(attack : Attack)

func damage(attack : Attack):
	print("hit")
	hit.emit(attack)
	#if health_component:
		#health_component.damage(attack)
