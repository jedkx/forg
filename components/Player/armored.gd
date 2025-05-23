extends CharacterBody2D

# Player scripti - tüm komponent sistemini bir araya getirir
func _ready():
	print("PLAYER")
	print("Layer: ", collision_layer)
	print("Mask: ", collision_mask)


func _ready1():
	# Oyuncuyu player grubuna ekle
	add_to_group("player")
	
	# Health değişim sinyalini izle
	var health_component = $Health
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
		health_component.died.connect(_on_player_died)
	
	print("Player: Oyuncu hazır!")

# Health değiştiğinde çağrılır
func _on_health_changed(new_health):
	print("Player: Sağlık değişti: ", new_health)
	# Burada UI güncellemesi yapabilirsiniz

# Oyuncu öldüğünde çağrılır
func _on_player_died():
	print("Player: Oyuncu öldü!")
	# Hareket componentini devre dışı bırak
	if has_node("Move"):
		$Move.set_process(false)
	
	# Sword componentini devre dışı bırak
	if has_node("Sword"):
		$Sword.stop_attack_loop()
	
	# Ölüm animasyonunu oynat (eğer AnimationComponent tarafından oynatılmadıysa)
	# Oyun durumunu güncelle, game over ekranı göster, vb.

# MoveComponent'in is_moving fonksiyonunu kullanarak hareket durumunu kontrol et
func is_moving() -> bool:
	if has_node("Move"):
		return $Move.is_moving()
	return false
