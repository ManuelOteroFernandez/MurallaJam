extends SpotBase

@export var person_pos: Vector2 = Vector2(1,0)
var _color:Color

func active():
	super.active()
	_color = Color(randf(),randf(),randf())
	$Person.initialize(person_pos, _color)

func _ready() -> void:
	super._ready()
	type = SpotBase.TYPE.PERSON
	_color = Color(randf(),randf(),randf())
	$Person.initialize(person_pos, _color)
	

func _on_taxi_in_area(taxi_in:Taxi):
	super._on_taxi_in_area(taxi_in)
	$Person.walk(taxi_in, $ProgressBar.get_remaining_time())

func _on_taxi_out_area(taxi_in:Taxi):
	super._on_taxi_out_area(taxi_in)
	$Person.stop()

func share_info_with_taxi():
	if taxi:
		taxi.person_in_taxi(type == TYPE.PERSON, _color)
