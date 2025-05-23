extends Node
class_name Health

signal died
signal health_changed(new_health)

@export var max_health: float = 100.0
var current_health: float
var is_dead_flag: bool = false

func _ready():
	current_health = max_health
	print("Health: Başlangıç sağlığı: ", current_health, "/", max_health)

func take_damage(amount: float) -> void:
	if is_dead_flag:
		print("Health: Zaten ölü, hasar uygulanmadı!")
		return
		
	print("Health: Hasar alındı! Miktar: ", amount)
	print("Health: Önceki sağlık: ", current_health)
	
	current_health -= amount
	current_health = max(0, current_health)  # Sağlığın 0'ın altına düşmesini engelle
	
	print("Health: Yeni sağlık: ", current_health)
	emit_signal("health_changed", current_health)
	
	# Görsel hasar efekti
	_play_hit_effect()
	
	# Ölüm kontrolü
	if current_health <= 0 and not is_dead_flag:
		is_dead_flag = true
		print("Health: Ölüm gerçekleşti!")
		emit_signal("died")
		
		# Görsel ölüm efekti
		_play_death_effect()

func heal(amount: float) -> void:
	if is_dead_flag:
		print("Health: Zaten ölü, iyileştirme uygulanmadı!")
		return
		
	print("Health: İyileştirme uygulanıyor! Miktar: ", amount)
	print("Health: Önceki sağlık: ", current_health)
	
	current_health += amount
	current_health = min(current_health, max_health)  # Maksimum sağlığı aşmayı engelle
	
	print("Health: Yeni sağlık: ", current_health)
	emit_signal("health_changed", current_health)

func is_dead() -> bool:
	return is_dead_flag or current_health <= 0

func revive(health_amount: float = max_health) -> void:
	if not is_dead_flag:
		return
		
	is_dead_flag = false
	current_health = min(health_amount, max_health)
	print("Health: Diriltildi! Yeni sağlık: ", current_health)
	emit_signal("health_changed", current_health)

# Hasar efekti - basit kırmızı yanma
func _play_hit_effect() -> void:
	var parent = get_parent()
	if parent.has_node("Sprite2D"):
		var sprite = parent.get_node("Sprite2D")
		sprite.modulate = Color(1, 0, 0)  # Kırmızıya boya
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = Color(1, 1, 1)  # Eski haline getir

# Ölüm efekti
func _play_death_effect() -> void:
	var parent = get_parent()
	# Eğer bir AnimationPlayer varsa ve "death" animasyonu varsa oynat
	if parent.has_node("AnimationPlayer"):
		var anim_player = parent.get_node("AnimationPlayer")
		if anim_player.has_animation("death"):
			anim_player.play("death")
	# Basit bir efekt olarak hafifçe sönümlendirme
	else:
		if parent.has_node("Sprite2D"):
			var sprite = parent.get_node("Sprite2D")
			var tween = create_tween()
			tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0.5), 0.5)
