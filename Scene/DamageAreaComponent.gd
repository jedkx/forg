extends Area2D

@export var damage_amount := 25

func _ready():
	# Collision sinyalını bağla
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Bir şey collision'a girdi: ", body.name)
	
	# Düşman mı kontrol et
	if not body.is_in_group("enemy"):
		print("Bu düşman değil: ", body.name)
		return
	
	print("Düşman tespit edildi: ", body.name)
	
	# HealthComponent var mı kontrol et (EnemyHealth node'u)
	var health_component = body.get_node_or_null("EnemyHealth")
	if not health_component:
		print("HealthComponent bulunamadı! Mevcut child'lar:")
		for child in body.get_children():
			print("  - ", child.name, " (", child.get_script(), ")")
		return
	
	print("HealthComponent bulundu: ", health_component.name)
	
	# Zaten ölü mü kontrol et
	if health_component.is_dead_flag:
		print("Düşman zaten ölü")
		return
	
	# Hasar ver
	print("Hasar veriliyor: ", damage_amount)
	health_component.take_damage(damage_amount)
	print("Hasar verildi: ", body.name, " - ", damage_amount, " hasar")
