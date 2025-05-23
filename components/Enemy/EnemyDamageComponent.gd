extends Node

class_name EnemyDamageComponent

@export var damage: float = 10.0
@export var target_group: String = "player"
@export var attack_cooldown: float = 0.5

var can_attack: bool = true
var attack_timer: Timer
var parent: CharacterBody2D

func _ready():
	# Ebeveyn node'a referans al
	parent = get_parent() as CharacterBody2D
	if not parent:
		push_error("EnemyDamageComponent: Ebeveyn CharacterBody2D değil!")
		return
		
	# Saldırı zamanlayıcısı oluştur
	attack_timer = Timer.new()
	attack_timer.one_shot = true
	attack_timer.wait_time = attack_cooldown
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

func _physics_process(_delta):
	if not parent:
		return
		
	# Çarpışma kontrolü
	for i in parent.get_slide_collision_count():
		var collision = parent.get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.is_in_group(target_group) and can_attack:
			apply_damage(collider)

func apply_damage(target_node):
	if not can_attack:
		return
		
	print("EnemyDamageComponent: Hedefe saldırılıyor!")
	
	# Health component'i ara (bu örnekte hem "Health" hem de "HealthComponent" kontrolü yapılıyor)
	var health = null
	if target_node.has_node("Health"):
		health = target_node.get_node("Health")
	elif target_node.has_node("HealthComponent"):
		health = target_node.get_node("HealthComponent")
	
	if health and health.has_method("take_damage"):
		health.take_damage(damage)
		print("EnemyDamageComponent: ", damage, " hasar verildi!")
		
		# Saldırı bekleme süresini başlat
		can_attack = false
		attack_timer.start()
	else:
		push_warning("EnemyDamageComponent: Hedefte Health/HealthComponent bulunamadı veya take_damage metodu yok!")

func _on_attack_timer_timeout():
	can_attack = true
