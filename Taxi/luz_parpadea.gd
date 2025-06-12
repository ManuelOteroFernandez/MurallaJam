extends Sprite2D

var _is_active: bool = true

func active_ligth(value:bool):
	_is_active = value
	var alpha = 1 if _is_active else 0
	if modulate.a != alpha:
		create_tween().tween_property(
			self,
			"modulate:a",
			alpha,
			randi_range(1,3)
		)
	
