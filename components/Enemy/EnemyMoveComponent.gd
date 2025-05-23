extends Node
class_name EnemyMoveComponent

@export var speed: float = 50.0
@export var target_group: String = "player"

var target: Node2D
var parent: CharacterBody2D
var animation_component: EnemyAnimationComponent

func _ready():
	# AnimationComponent referansını al
	animation_component = get_parent().get_node_or_null("EnemyAnimation")
	
	# Ebeveyn node'a referans al
	parent = get_parent() as CharacterBody2D
	if not parent:
		push_error("EnemyMoveComponent: Ebeveyn CharacterBody2D değil!")
		return
	
	# Hedefi bul
	target = get_tree().get_first_node_in_group(target_group)
	if not target:
		push_warning("EnemyMoveComponent: '", target_group, "' grubunda bir hedef bulunamadı!")

func _physics_process(_delta):
	if not parent or not target:
		return
		
	# Hedefe doğru yön
	var direction = (target.global_position - parent.global_position).normalized()
	var move_vector = direction * speed
	
	# Hareket et
	parent.velocity = move_vector
	parent.move_and_slide()
	
	# Animasyon güncellemesi 
	if animation_component:
			animation_component.update_movement_animation(direction)
		
func get_target() -> Node2D:
	return target
