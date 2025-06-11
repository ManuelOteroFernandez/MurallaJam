extends Control


@export var game_timer_manager: GameTimerManager

func _ready() -> void:
	_update_clock()
	
func _update_clock():
	var timerDict = game_timer_manager.get_time_game()
	$HBoxContainer/rtlMin.text = str(timerDict['min']).pad_zeros(2)
	$HBoxContainer/rtlSec.text = str(timerDict['sec']).pad_zeros(2)

func _process(_delta: float) -> void:
	_update_clock()
