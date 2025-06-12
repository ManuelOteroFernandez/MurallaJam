extends Node2D
class_name SpotBase

enum TYPE {
	NONE,
	PERSON,
	PARTY
}

signal spot_visibility(is_on_screen: bool)
signal deactivate

@export var type = TYPE.PERSON

func _ready() -> void:
	visible = false
	$ProgressBar.timeout.connect(_on_interaction_completed)
	
func active():
	visible = true

func _on_interaction_completed():
	deactivate.emit()
	$Icon.stop()
	
	await create_tween().tween_property(self,"modulate",Color.TRANSPARENT,1).finished
	visible = false
	modulate = Color.WHITE

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	spot_visibility.emit(true)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	spot_visibility.emit(false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_on_taxi_in_area(body as Taxi)
		
func _on_taxi_in_area(_taxi:Taxi):
	$ProgressBar.start_count()
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_on_taxi_out_area(body as Taxi)
		
func _on_taxi_out_area(_taxi:Taxi):
	$ProgressBar.stop_count()
