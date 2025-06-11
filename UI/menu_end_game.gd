extends Control
class_name MenuEndGame

@onready var btn_back = $MarginContainer/VBoxContainer/btnBack
@onready var rtl_money = $MarginContainer/VBoxContainer/rtlMoney
@onready var text_label = $MarginContainer/VBoxContainer/RichTextLabel 

func _ready() -> void:
	rtl_money.end_countdown.connect(_on_end_countdown)
	rtl_money.initilize(PointManager.points)

func _on_tree_entered() -> void:
	await get_tree().create_timer(2).timeout
	rtl_money.start_countdown()

func _on_end_countdown():
	text_label.text = "Ooops!!"
	btn_back.modulate = Color.TRANSPARENT
	btn_back.visible = true
	create_tween().tween_property(btn_back,"modulate",Color.WHITE,1)


func _on_btn_back_pressed() -> void:
	var sm = get_tree().current_scene as SceneManager
	sm.open_main_menu()
