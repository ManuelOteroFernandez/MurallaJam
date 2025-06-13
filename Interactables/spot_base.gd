extends Node2D
class_name SpotBase

enum TYPE {
	NONE,
	PERSON,
	PARTY
}

signal spot_visibility(is_on_screen: bool)
signal deactivate
signal activate

@export var type = TYPE.PERSON

var _is_deactivating:bool = false

var taxi:Taxi


func _ready() -> void:
	visible = false
	$ProgressBar.timeout.connect(_on_interaction_completed)
	
func active():
	activate.emit()
	visible = true
	$Area2D/CollisionShape2D.disabled = false
	
func deactive():
	_is_deactivating = true
	deactivate.emit()	
	share_info_with_taxi()
	$Area2D/CollisionShape2D.disabled = true
	
	await create_tween().tween_property(self,"modulate",Color.TRANSPARENT,1).finished
	_is_deactivating = false
	visible = false
	modulate = Color.WHITE
	

func _on_interaction_completed():
	deactive()
	

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	spot_visibility.emit(true)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	spot_visibility.emit(false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_on_taxi_in_area(body as Taxi)
		
func _on_taxi_in_area(taxi_in:Taxi):
	taxi = taxi_in
	$ProgressBar.start_count()
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_on_taxi_out_area(body as Taxi)
		
func _on_taxi_out_area(_taxi_in:Taxi):
	taxi = null
	$ProgressBar.stop_count()

func share_info_with_taxi():
	if taxi:
		taxi.person_in_taxi(type == TYPE.PERSON)

func is_spot_active():
	return visible and not _is_deactivating
