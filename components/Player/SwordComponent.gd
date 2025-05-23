extends Node
class_name SwordComponent

## Ayarlar
@export var attack_interval := 4.0  # Saldırı aralığı (saniye)

## Dahili referanslar
var animation_component: AnimationComponent

## Saldırı zamanlayıcısı
var attack_timer: Timer

var direction := Vector2.ZERO


func _ready():
	# AnimationComponent referansını al
	animation_component = get_parent().get_node_or_null("Animation")
	if not animation_component:
		push_error("SwordComponent: AnimationComponent bulunamadı!")
	
	# Timer node'u oluştur ve yapılandır
	attack_timer = Timer.new()
	attack_timer.name = "AttackTimer"
	attack_timer.wait_time = attack_interval
	attack_timer.one_shot = false
	add_child(attack_timer)
	
	# Timer sinyalini bağla
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	
	# Saldırı döngüsünü başlat
	start_attack_loop()

func start_attack_loop():
	# Saldırı zamanlayıcısını başlat
	attack_timer.start()

func stop_attack_loop():
	# Saldırıyı durdur
	attack_timer.stop()

func _on_attack_timer_timeout():
	# Zamanlayıcı her dolduğunda saldırı başlat
	perform_attack()

func perform_attack():
	# Saldırı animasyonunu oynat
	if animation_component:
		animation_component.play_attack_animation()

func set_attack_interval(new_interval: float):
	# Saldırı aralığını dinamik olarak değiştir
	attack_interval = new_interval
	if attack_timer:
		attack_timer.wait_time = attack_interval
