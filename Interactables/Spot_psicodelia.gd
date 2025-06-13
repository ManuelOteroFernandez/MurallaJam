extends Sprite2D

var color_tween: Tween = null
var scale_tween: Tween = null

@export var cycle_duration_color: float = 1.5  # Duración del ciclo de cambio de color
@export var cycle_duration_scale: float = 1   # Duración del ciclo de pulsación de escala
@export var min_scale: float = 0.6             # Escala mínima
@export var max_scale: float = 0.8             # Escala máxima

func stop():
	color_tween.kill()
	scale_tween.kill()

func _ready():
	
	start_psychedelic_animation()
	
func start_psychedelic_animation():
	animate_color()
	animate_scale()

func animate_color():
	if color_tween:
		color_tween.kill() # Detiene el tween anterior si existe

	color_tween = create_tween().set_loops() # Hace que se repita infinitamente

	# Secuencia de colores vibrantes
	color_tween.tween_property(self, "modulate", Color.RED, cycle_duration_color / 6.0)
	color_tween.tween_property(self, "modulate", Color.ORANGE, cycle_duration_color / 6.0)
	color_tween.tween_property(self, "modulate", Color.YELLOW, cycle_duration_color / 6.0)
	color_tween.tween_property(self, "modulate", Color.GREEN, cycle_duration_color / 6.0)
	color_tween.tween_property(self, "modulate", Color.BLUE, cycle_duration_color / 6.0)
	color_tween.tween_property(self, "modulate", Color.MAGENTA, cycle_duration_color / 6.0)
	color_tween.tween_property(self, "modulate", Color.RED, cycle_duration_color / 6.0) # Vuelve al inicio

	# Opcional: Para añadir un efecto de "flicker" o transparencia cambiante
	color_tween.tween_property(self, "modulate:a", 0.2, cycle_duration_color / 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	color_tween.tween_property(self, "modulate:a", 1.0, cycle_duration_color / 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func animate_scale():
	if scale_tween:
		scale_tween.kill()

	scale_tween = create_tween().set_loops()
	scale_tween.tween_property(self, "scale", Vector2(max_scale, max_scale), cycle_duration_scale / 2.0) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	scale_tween.tween_property(self, "scale", Vector2(min_scale, min_scale), cycle_duration_scale / 2.0) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# Opcional: Reiniciar animaciones si el nodo se reactiva (por ejemplo, al salir de un árbol de escena y volver)
func _notification(what):
	if what == NOTIFICATION_ENTER_TREE:
		if color_tween and not color_tween.is_running():
			start_psychedelic_animation()
