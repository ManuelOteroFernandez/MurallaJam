extends Control




func _on_button_pressed() -> void:
	var sm = get_tree().current_scene as SceneManager
	if sm:
		sm.close_menu()
