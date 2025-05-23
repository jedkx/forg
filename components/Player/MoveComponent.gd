extends Node
class_name MoveComponent

@export var speed := 100.0
var direction := Vector2.ZERO
var animation_component: AnimationComponent

func _ready():
	# AnimationComponent referansını al
	animation_component = get_parent().get_node_or_null("Animation")


func _physics_process(_delta: float) -> void:
	# Yön girişini al
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var parent = get_parent()
	
	if parent is CharacterBody2D:
		# Hareket - her zaman çalışır
		parent.velocity = direction * speed
		parent.move_and_slide()
		
		# Animasyon güncellemesi - AnimationComponent aracılığıyla yapılır
		if animation_component:
			animation_component.update_movement_animation(direction)
		
# Hareket durumunu kontrol etmek için
func is_moving() -> bool:
	return direction != Vector2.ZERO
