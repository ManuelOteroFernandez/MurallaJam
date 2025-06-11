extends CharacterBody2D
class_name Taxi

signal recieve_damage

const SPEED = 15000.0
const SPEED_REVERSE = -5000

const STOP_VELOCITY = 0.01
const ACCELERATION_VELOCITY = 0.02
const ROTATION_VELOCITY = 2

var _movement_input: int = 0
var _current_speed: float = 0
var _is_damaged = false
var _last_col_normal: Vector2 = Vector2.ZERO

func _ready() -> void:
	$DamageTimer.timeout.connect(_on_damage_expired)

func _process(_delta: float) -> void:
	_rotation_input()
	
func _rotation_input():
	if _is_damaged: return
	
	var left_input = Input.is_action_pressed("turn-left")
	var rigth_input = Input.is_action_pressed("turn-right")
	
	if (left_input or rigth_input) and left_input != rigth_input:
		if left_input:
			_turn(-1)
		else:
			_turn(1)

func _physics_process(delta: float) -> void:

	if _is_damaged:
		_stop()
		velocity = (_last_col_normal * abs(_current_speed) / 2) * delta
		move_and_slide()
	else:
		_move(delta)
		
	if get_slide_collision_count() > 0:
		var col:KinematicCollision2D = get_last_slide_collision()
		_damage(col)

func _damage(col:KinematicCollision2D):
	recieve_damage.emit()
	_last_col_normal = col.get_normal()
	_is_damaged = true
	$DamageTimer.start()

func _move(delta: float) -> void:
	if _movement_input < 0:
		_accelerate()
	elif _movement_input > 0:
		_reverse()
	else:
		_stop()
	
	if _current_speed == 0:
		return
	
	velocity = global_transform.basis_xform(Vector2.UP) * _current_speed * delta
	
	move_and_slide()
	
		
func _input(event: InputEvent) -> void:	
	if event.is_action_pressed("accelerate"):
		_movement_input = -1
	if event.is_action_released("accelerate"):
		_movement_input = 0
		
	if event.is_action_pressed("reverse"):
		_movement_input = 1
	if event.is_action_released("reverse"):
		_movement_input = 0
		
func _accelerate():
	_current_speed = lerpf(_current_speed,SPEED,ACCELERATION_VELOCITY)

func _reverse():
	_current_speed = lerpf(_current_speed,SPEED_REVERSE,ACCELERATION_VELOCITY)
	
func _stop():
	_current_speed = lerpf(_current_speed,0,STOP_VELOCITY)

func _turn(direction:int):
	var delta_rot = 0
	if _current_speed > 0:
		delta_rot = ROTATION_VELOCITY * (_current_speed / SPEED)
	else:
		delta_rot = ROTATION_VELOCITY * (_current_speed / SPEED_REVERSE)
	
	rotation_degrees = move_toward(rotation_degrees, rotation_degrees+90*direction, delta_rot)
	
func _on_damage_expired():
	_is_damaged = false
	_current_speed = 0
		
