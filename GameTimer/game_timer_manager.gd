extends Node
class_name GameTimerManager


func _on_timer_timeout() -> void:
	pass # Replace with function body.

func get_time_game() -> Dictionary:
	var time_left = $Timer.time_left
	print(time_left)
	var minutes :int = time_left / 60
	var sec: int = int(time_left) % 60
	
	return { 
		"min": minutes,
		"sec": sec
	}
