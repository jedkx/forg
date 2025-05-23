extends Node
class_name HealthComponent

signal died
signal health_changed(new_health)

@export var max_health: float
var current_health: float
var animation_component: AnimationComponent

func _ready():
	current_health = max_health
	
	# AnimationComponent referansını al
	animation_component = get_parent().get_node_or_null("Animation")


func take_damage(amount: float) -> void:
	current_health -= amount
	emit_signal("health_changed", current_health)
	
	# Hasar animasyonunu oynat
	if animation_component:
		animation_component.play_hit_animation()
	
	if current_health <= 0:
		emit_signal("died")

func heal(amount: int) -> void:
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health)

func is_dead() -> bool:
	return current_health <= 0
