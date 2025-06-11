extends Control

func _ready() -> void:
	PointManager.change_client_points.connect(_on_change_client_points)
	PointManager.change_points.connect(_on_change_points)

func _on_change_client_points(value:int):
	$etlClientPoints.visible = value > 0
	$etlClientPoints.text = "{0}€".format([value])
	
func _on_change_points(value:int):
	$etlPoints.text = "{0}€".format([value])
