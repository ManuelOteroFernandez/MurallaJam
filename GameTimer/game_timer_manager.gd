extends Node
class_name GameTimerManager


func _on_timer_timeout() -> void:
	var sm = get_tree().current_scene as SceneManager
	sm.open_main_menu()

func get_time_game() -> Dictionary:
	var time_left = $Timer.time_left
	var minutes :int = time_left / 60
	var sec: int = int(time_left) % 60
	
	return { 
		"min": minutes,
		"sec": sec
	}
