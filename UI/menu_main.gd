extends Control

var sm: SceneManager

func _ready() -> void:
	sm = get_tree().current_scene as SceneManager

func _on_btn_start_pressed() -> void:
	if sm:
		sm.open_level(0)
	else:
		printerr("MenuMain not find SceneManaer")
