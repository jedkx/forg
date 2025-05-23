extends Area2D

@export var damage: float = 20.0

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("enemy") and body.has_node("EnemyHealth"):
		var health_node = body.get_node("EnemyHealth")
		if health_node and health_node.has_method("take_damage"):
			health_node.take_damage(damage)
