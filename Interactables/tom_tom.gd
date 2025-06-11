extends Control
class_name TomTom

@export var curve: Curve
@onready var center_control = $Control
@onready var arrow = $Control/Arrow

func look_to(angle: float):
	if center_control:
		center_control.rotation = angle + deg_to_rad(90)
	if arrow:
		arrow.position.y = -300 + curve.sample(abs(center_control.rotation_degrees/360)) * -200
