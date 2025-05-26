extends Node

@export var mouse_enemy_scene: PackedScene
@export var spawn_interval := 1.5
@export var spawn_duration := 30.0
@export var spawn_margin := 200

var spawn_timer := 0.0
var total_timer := 0.0
var spawning := true

var spawn_count := 0
var player: Node2D

func _ready():
	player = get_parent().get_node("Player") # Oyuncunun yolunu kontrol et
	if player:
		print("Oyuncu bulundu:", player.name)
	else:
		print("HATA: Oyuncu bulunamadı")
func _process(delta):
	if not spawning:
		return

	spawn_timer += delta
	total_timer += delta

	if total_timer >= spawn_duration:
		spawning = false
		print("Spawn süresi tamamlandı. Toplam spawn edilen düşman sayısı: %d" % spawn_count)
		return

	if spawn_timer >= spawn_interval:
		spawn_timer = 0
		spawn_mouse()

func spawn_mouse():
	if not player:
		return

	var spawn_pos = get_offscreen_position(player.global_position)
	var mouse = mouse_enemy_scene.instantiate()
	mouse.position = spawn_pos
	get_parent().add_child(mouse)

	spawn_count += 1
	print("Düşman spawnlandı #%d konum: (%.2f, %.2f)" % [spawn_count, spawn_pos.x, spawn_pos.y])

func get_offscreen_position(player_pos: Vector2) -> Vector2:
	var viewport_size = get_viewport().get_visible_rect().size
	var half_width = viewport_size.x / 2
	var half_height = viewport_size.y / 2

	var direction = randi() % 4
	match direction:
		0: # üst
			return player_pos + Vector2(randf_range(-half_width, half_width), -half_height - spawn_margin)
		1: # sağ
			return player_pos + Vector2(half_width + spawn_margin, randf_range(-half_height, half_height))
		2: # alt
			return player_pos + Vector2(randf_range(-half_width, half_width), half_height + spawn_margin)
		3: # sol
			return player_pos + Vector2(-half_width - spawn_margin, randf_range(-half_height, half_height))
		_:
			return player_pos
