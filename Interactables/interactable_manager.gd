extends Node

@export var tomTom: TomTom 
@export var player: Taxi

var _active_spot: SpotBase

func _ready() -> void:
	if not tomTom:
		printerr("No TomTom")
	if not player:
		printerr("No Taxi")
	if get_child_count() == 0:
		printerr("No Spots childrens")
		
	_change_spot_active()

func _change_spot_active():
	var search_spot_type = SpotBase.TYPE.PERSON
	
	if _active_spot:
		_active_spot.spot_visibility.disconnect(_on_spot_visibility_change)
		_active_spot.deactivate.disconnect(_on_spot_deactivate)
		if _active_spot.type == SpotBase.TYPE.PERSON:
			search_spot_type = SpotBase.TYPE.PARTY
	
	_active_spot = get_children().filter(
		func (x): return x.type == search_spot_type
	).pick_random() as SpotBase
	
	_active_spot.spot_visibility.connect(_on_spot_visibility_change)
	_active_spot.deactivate.connect(_on_spot_deactivate)
	
	_active_spot.active()
	adjust_tomtom()
	tomTom.show()

func _on_spot_visibility_change(is_on_screen:bool):
	if is_on_screen:
		tomTom.hide()
	else:
		tomTom.show()
	
func _on_spot_deactivate():
	_change_spot_active()

func _process(_delta: float) -> void:
	adjust_tomtom()		

func adjust_tomtom():
	if _active_spot:
		tomTom.look_to(player.global_position.angle_to_point(_active_spot.global_position))
