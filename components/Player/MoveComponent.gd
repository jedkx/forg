extends Node
class_name MoveComponent

@export var speed := 100.0
var direction := Vector2.ZERO
var animation_component: AnimationComponent

func _ready():
	# AnimationComponent referansını al
	animation_component = get_parent().get_node_or_null("Animation")


func _physics_process(_delta: float) -> void:
	
	var parent = get_parent()
	# Yön girişini al
	if parent is CharacterBody2D and "current_direction" in parent:
		direction = parent.current_direction
	
	if parent is CharacterBody2D:
		# Hareket - her zaman çalışır
		parent.velocity = direction * speed
		parent.move_and_slide()
		
		
# Hareket durumunu kontrol etmek için
func is_moving() -> bool:
	return direction != Vector2.ZERO
