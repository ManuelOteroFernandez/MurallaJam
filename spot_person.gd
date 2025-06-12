extends SpotBase

@export var color: Color = Color.AQUA
@export var person_pos: Vector2 = Vector2(1,0)

func _ready() -> void:
	super._ready()
	type = SpotBase.TYPE.PERSON


func _on_taxi_in_area(taxi:Taxi):
	super._on_taxi_in_area(taxi)
	$Person.walk(taxi, $ProgressBar.get_remaining_time())

func _on_taxi_out_area(taxi:Taxi):
	super._on_taxi_out_area(taxi)
	$Person.stop()
