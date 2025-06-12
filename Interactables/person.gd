extends Sprite2D

var _target:Node2D
var _max_time: float = 0
var _acumulated_time: float = 0

func _ready() -> void:
	set_process(false)

func walk(target:Node2D,time:float):
	_target = target
	_acumulated_time = 0
	_max_time = time
	set_process(true)
	
func stop():
	_target = null
	_acumulated_time = 0
	_max_time = 0
	set_process(false)
	

func _process(delta: float) -> void:
	if _acumulated_time >= _max_time:
		stop()
		visible = false
	
	_acumulated_time += delta
	global_position = global_position.lerp(_target.global_position,0.01)
	
func _on_spot_base_deactivate() -> void:
	visible = true
