extends Node

class_name EnemyAnimationComponent

@onready var anim_player: AnimationPlayer = get_parent().get_node_or_null("AnimationPlayer")
@onready var sprite: Sprite2D = get_parent().get_node_or_null("Sprite2D")

func update_movement_animation(direction: Vector2):
	if not anim_player:
		return
		
	# Sprite yönünü güncelle (eğer yön belirtilmişse)
	if sprite and direction.x != 0:
		sprite.flip_h = direction.x < 0
		
	# Hareket durumuna göre animasyonu güncelle
	if direction != Vector2.ZERO:
		if anim_player.current_animation != "walk":
			anim_player.play("walk")
	else:
		if anim_player.current_animation != "idle":
			anim_player.play("idle")
			
			
func play_hit_animation():
	if sprite:
		# Kırmızı yanma efekti
		for i in range(3):
			sprite.modulate = Color(2.0, 0.0, 0.0)  # Parlak kırmızı
			await get_tree().create_timer(0.05).timeout
			sprite.modulate = Color(1, 1, 1)  # Normal renk
			if i < 2:  # Son turda bekleme yok
				await get_tree().create_timer(0.05).timeout
