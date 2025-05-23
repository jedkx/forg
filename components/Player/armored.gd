extends CharacterBody2D

var current_direction := Vector2.RIGHT  # Varsayılan yön

@onready var sprite: Sprite2D = $Sprite2D  # Sprite'ın yolu uygun şekilde değiştir

func _ready():
	add_to_group("player")

	var health_component = $Health
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
		health_component.died.connect(_on_player_died)
	
	print("Player: Oyuncu hazır!")

func _physics_process(_delta):
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	current_direction = input_vector

	if abs(input_vector.x) > 0.1:
		sprite.flip_h = input_vector.x < 0


func _on_health_changed(new_health):
	print("Player: Sağlık değişti: ", new_health)

func _on_player_died():
	print("Player: Oyuncu öldü!")
	if has_node("Move"):
		$Move.set_process(false)
	if has_node("Sword"):
		$Sword.stop_attack_loop()

func is_moving() -> bool:
	if has_node("Move"):
		return $Move.is_moving()
	return false
