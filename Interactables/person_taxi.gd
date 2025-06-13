extends PersonBase
class_name PersonTaxi

var target_pos:Vector2

func _ready() -> void:
	super._ready()
	PointManager.client_0_points.connect(client_out)

func client_out():
	reparent(get_parent().get_parent())
	var end_pos = global_position + Vector2(randf_range(0,100),randf_range(0,100))
	walk(end_pos,2)

func walk(end_pos:Vector2,time:float):
	target_pos = end_pos
	_acumulated_time = 0
	_max_time = time
	set_process(true)

func _process(delta: float) -> void:
	_move_to(target_pos,delta)

func deactivate():
	await create_tween().tween_property(self,"modulate:a",0,1).finished
	queue_free()
