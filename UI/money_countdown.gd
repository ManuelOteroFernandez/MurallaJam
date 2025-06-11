extends RichTextLabel

signal end_countdown

var initial_value = 0
var end_value = 0
var duration = 2.0
var elapsed_time = 0

func initilize(value:int):
	initial_value = value
	_update_text_value(initial_value)

func _update_text_value(value:int):
	text = "{0}€".format([str(value).pad_zeros(3)])

func start_countdown():
	set_process(true)

func _ready() -> void:
	set_process(false)

func _process(delta):	
	elapsed_time += delta
	
	if elapsed_time <= duration:
		var t = elapsed_time / duration

		_update_text_value(lerp(initial_value, end_value, t))
	else:
		_update_text_value(end_value)
		end_countdown.emit()
		set_process(false)
