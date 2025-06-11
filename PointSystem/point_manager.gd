extends Node

signal change_points(new_points:int)
signal change_client_points(new_points:int)

var interactableManager: InteractableManager
var player: Taxi

var _start_client_points: int = 100

var client_points:int = _start_client_points
var points:int = 0
var sm:SceneManager

func _ready() -> void:
	sm = get_tree().current_scene as SceneManager
	sm.open_level_end_signal.connect(initialize)

func initialize() -> void:
	if sm.is_open_any_menu(): return
	
	player = get_tree().get_first_node_in_group("player")
	if not player.recieve_damage.is_connected(_on_player_damage):
		player.recieve_damage.connect(_on_player_damage)
		
	interactableManager = get_tree().get_first_node_in_group("interactableManager")
	if not interactableManager.change_spot.is_connected(_on_change_spot):
		interactableManager.change_spot.connect(_on_change_spot)

func _on_player_damage():
	if interactableManager.get_active_spot_type() == SpotBase.TYPE.PARTY:
		client_points -= randi() % 10 + 5
		if client_points < 0:
			client_points = 0
		change_client_points.emit(client_points)

func _on_change_spot(_new_type: SpotBase.TYPE,old_type: SpotBase.TYPE):
	if old_type == SpotBase.TYPE.PARTY:
		points += client_points
		client_points = 0
		change_points.emit(points)
		change_client_points.emit(client_points)
	elif old_type == SpotBase.TYPE.PERSON:
		client_points = _start_client_points
		change_client_points.emit(client_points)
		
