extends Node
class_name AnimationComponent

# Referanslar
@onready var anim_player: AnimationPlayer = get_parent().get_node_or_null("AnimationPlayer")
@onready var sprite: Sprite2D = get_parent().get_node_or_null("Sprite2D")

# Durum değişkeni
var is_attacking := false

func _ready():
	if not anim_player:
		push_error("AnimationComponent: AnimationPlayer bulunamadı!")

func _physics_process(_delta: float) -> void:
	update_movement_animation()

func play_attack_animation():
	if not anim_player:
		return

	is_attacking = true

	anim_player.stop()
	anim_player.play("sword")

	await anim_player.animation_finished

	is_attacking = false

	# Saldırı sonrası hareket animasyonuna dön
	update_movement_animation()

func update_movement_animation():
	if not anim_player:
		return

	if is_attacking:
		return

	var direction = get_parent().current_direction

	if direction != Vector2.ZERO:
		if anim_player.current_animation != "walk":
			anim_player.play("walk")
	else:
		if anim_player.current_animation != "idle":
			anim_player.play("idle")

# Doğrudan belirli bir animasyonu oynatmak için
func play_animation(anim_name: String):
	if anim_player and anim_player.has_animation(anim_name):
		anim_player.play(anim_name)

# Özel durum animasyonları için (örneğin hasar alırken)
func play_hit_animation():
	if sprite:
		for i in range(3):
			sprite.modulate = Color(2.0, 0.0, 0.0)
			await get_tree().create_timer(0.05).timeout
			sprite.modulate = Color(1, 1, 1)
			if i < 2:
				await get_tree().create_timer(0.05).timeout
