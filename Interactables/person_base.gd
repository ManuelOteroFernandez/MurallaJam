extends Sprite2D
class_name PersonBase

var _max_time: float = 0
var _acumulated_time: float = 0
var _initial_position:Vector2


func initialize(pos:Vector2, color:Color):
	_initial_position = pos
	modulate = color

func _ready() -> void:
	set_process(false)
	
func stop():
	_acumulated_time = 0
	_max_time = 0
	set_process(false)

func deactivate():
	visible = false

func _move_to(pos:Vector2,delta:float):
	if _acumulated_time >= _max_time:
		stop()
		deactivate()
		return
	
	_acumulated_time += delta
	
	var dist_res = global_position.distance_to(pos)
	
	if dist_res <= 0:
		return
	
	var step = (_max_time - _acumulated_time) / delta
	
	global_position += (pos - global_position).normalized() * dist_res/step
