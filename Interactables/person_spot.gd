extends PersonBase

var _target:Node2D


func walk(target:Node2D,time:float):
	_target = target
	_acumulated_time = 0
	_max_time = time
	set_process(true)
	
func stop():
	super.stop()
	_target = null

func _process(delta: float) -> void:
	if _target != null: 
		_move_to(_target.global_position,delta)
	
func _move_to(pos:Vector2,delta:float):
	if _acumulated_time >= _max_time:
		stop()
		visible = false
		return
	
	_acumulated_time += delta
	
	var dist_res = global_position.distance_to(pos)
	
	if dist_res <= 0:
		return
	
	var step = (_max_time - _acumulated_time) / delta
	
	global_position += (pos - global_position).normalized() * dist_res/step
	
func _on_spot_base_activate() -> void:
	position = _initial_position
	visible = true

func _on_spot_base_deactivate() -> void:
	stop()
	visible = false
