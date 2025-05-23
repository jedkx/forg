extends CharacterBody2D


func _ready():
	# Düşmanı düşman grubuna ekle
	add_to_group("enemy")
	
	# Health component sinyallerini bağla
	var health = $EnemyHealth
	if health:
		health.died.connect(_on_died)
		health.health_changed.connect(_on_health_changed)
	
	print("Enemy: Düşman hazır!")

func _on_died():
	print("Enemy: Düşman öldü!")
	# Hareket ve hasar komponentlerini devre dışı bırak
	if has_node("EnemyMove"):
		$EnemyMove.set_process(false)
		$EnemyMove.set_physics_process(false)
	
	if has_node("EnemyDamaged"):
		$EnemyDamage.set_process(false)
		$EnemyDamage.set_physics_process(false)
	
	# İsteğe bağlı: Belirli bir süre sonra düşmanı yok et
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _on_health_changed(new_health):
	print("Enemy: Sağlık değişti: ", new_health)
