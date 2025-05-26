extends Area2D

@onready var parent_sprite = get_parent().get_node("Sprite2D")
@export var damage: float = 20.0

var last_flip_state: bool = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	last_flip_state = parent_sprite.flip_h
	update_scale()
	
func _process(_delta):
	if parent_sprite.flip_h != last_flip_state:
		last_flip_state = parent_sprite.flip_h
		update_scale()

func update_scale():
	scale.x = -1 if parent_sprite.flip_h else 1

func _on_body_entered(body):
	if body.is_in_group("enemy") and body.has_node("EnemyHealth"):
		var health_node = body.get_node("EnemyHealth")
		if health_node and health_node.has_method("take_damage"):
			health_node.take_damage(damage)
