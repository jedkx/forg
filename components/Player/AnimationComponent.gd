extends Node
class_name AnimationComponent

# Referanslar
@onready var anim_player: AnimationPlayer = get_parent().get_node_or_null("AnimationPlayer")
@onready var sprite: Sprite2D = get_parent().get_node_or_null("Sprite2D")
@onready var damage_polygon: CollisionPolygon2D = get_parent().get_node_or_null("DamageArea/CollisionPolygon2D")

# Durum değişkenleri
var is_attacking := false
var current_direction := Vector2.ZERO  # Mevcut yönü takip etmek için

func _ready():
	# Animasyon oynatıcıyı kontrol et
	if not anim_player:
		push_error("AnimationComponent: AnimationPlayer bulunamadı!")
		
func apply_sword_damage():
	if damage_polygon:
		print("Hasar aktif")
		damage_polygon.disabled = false
		await get_tree().create_timer(0.5).timeout # Hasar süresi burada ayarlanır
		damage_polygon.disabled = true
		print("Hasar kapalı")

func play_attack_animation():
	if not anim_player:
		return
		
	# Saldırı durumunu güncelle
	is_attacking = true
	
	# Sprite yönünü mevcut yöne göre ayarla
	update_sprite_direction(current_direction)
	
	# Mevcut animasyonu durdur ve saldırı animasyonunu başlat
	anim_player.stop()
	anim_player.play("sword")
	
	# Saldırı animasyonu tamamlanana kadar bekle
	await anim_player.animation_finished
	
	# Saldırı durumunu güncelle
	is_attacking = false
	
	# Hareket durumuna göre animasyonu güncelle
	update_movement_animation(current_direction)

func update_movement_animation(direction: Vector2):
	if not anim_player:
		return
	
	# Mevcut yönü güncelle
	current_direction = direction
	
	# Sprite yönünü her zaman güncelle (saldırı sırasında da)
	update_sprite_direction(direction)
		
	# Eğer saldırı animasyonu oynatılıyorsa, animasyonu değiştirme
	if is_attacking:
		return
		
	# Hareket durumuna göre animasyonu güncelle
	if direction != Vector2.ZERO:
		if anim_player.current_animation != "walk":
			anim_player.play("walk")
	else:
		if anim_player.current_animation != "idle":
			anim_player.play("idle")

# Sprite yönünü güncellemek için ayrı fonksiyon
func update_sprite_direction(direction: Vector2):
	if sprite and direction.x != 0:
		sprite.flip_h = direction.x < 0

# Doğrudan belirli bir animasyonu oynatmak için
func play_animation(anim_name: String):
	if anim_player and anim_player.has_animation(anim_name):
		anim_player.play(anim_name)
		
# Özel durum animasyonları için
func play_hit_animation():
	if sprite:
		# Kırmızı yanma efekti
		for i in range(3):
			sprite.modulate = Color(2.0, 0.0, 0.0)  # Parlak kırmızı
			await get_tree().create_timer(0.05).timeout
			sprite.modulate = Color(1, 1, 1)  # Normal renk
			if i < 2:  # Son turda bekleme yok
				await get_tree().create_timer(0.05).timeout
