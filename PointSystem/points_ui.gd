extends Control

@export var point_manager: PointManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	point_manager.change_client_points.connect(_on_change_client_points)
	point_manager.change_points.connect(_on_change_points)

func _on_change_client_points(value:int):
	$etlClientPoints.visible = value > 0
	$etlClientPoints.text = "{0}€".format([value])
	
func _on_change_points(value:int):
	$etlPoints.text = "{0}€".format([value])
