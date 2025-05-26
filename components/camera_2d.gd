# Camera2D script'i
extends Camera2D

@export var target: Node2D  # Inspector'dan player'ı ata
@export var follow_speed: float = 5.0

func _process(delta):
	if target:
		global_position = global_position.lerp(target.global_position, follow_speed * delta)
