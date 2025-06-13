extends ProgressBar

signal timeout

@export var max_time: float = 3

var is_running = false

var _time_accumulated: float = 0

func start_count():
	set_process(true)
	is_running = true
	show()
	
func stop_count():
	is_running = false
	
func _process(delta: float) -> void:
	if is_running:
		_time_accumulated += delta
		set_value_no_signal(100*_time_accumulated/max_time)
		if _time_accumulated >= max_time:
			hide()
			is_running = false
			set_process(false)
			value = 0
			_time_accumulated = 0
			timeout.emit()
			
	elif value > 0:
		_time_accumulated -= delta
		set_value_no_signal(100*_time_accumulated/max_time)
		if value <= 0:
			hide()
	
func get_remaining_time() -> float:
	return max_time - _time_accumulated
