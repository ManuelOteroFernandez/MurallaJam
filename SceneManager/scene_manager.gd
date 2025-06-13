class_name SceneManager extends Node

@export var transition = TransitionManagerClass.Transitions.FADE

@onready var menu_main = preload("res://UI/menu_main.tscn")
@onready var menu_controls = preload("res://UI/menu_controls.tscn")
@onready var menu_credits = preload("res://UI/menu_credits.tscn")
@onready var menu_end_game = preload("res://UI/MenuEndGame.tscn")
@onready var tsm : TransitionManagerClass = $UI/TransitionManager

signal open_level_end_signal
signal pause_signal

enum MENU_TYPE { CREDITS, CONTROLS }
enum Transition_to { None, MainMenu, Level, Credits, Controls, CloseMenu, EndGame }

var next_scene = null
var current_transition = Transition_to.None
var current_level_index = 0

const level_list = [
	"res://Levels/level01.tscn"
]

func _ready() -> void:
	tsm.mid_transition_signal.connect(self._on_mid_transition)
	tsm.mid_transition_signal.connect(self._on_end_transition)
	
	tsm.end_transition(transition)
	current_transition = Transition_to.MainMenu
	_on_mid_open_main_menu()
	

func open_level(level_index:int):
	
	if level_index < len(level_list):
		next_scene = level_list[level_index]
		current_level_index = level_index
		current_transition = Transition_to.Level
		pause(true)
		tsm.start_transition(transition)
	else:
		current_level_index = 0
		open_main_menu()

func open_next_level():
	open_level(current_level_index+1)

func open_main_menu():
	current_transition = Transition_to.MainMenu
	pause(true)
	tsm.start_transition(transition)

func open_menu_end_game():
	current_transition = Transition_to.EndGame
	pause(true)
	tsm.start_transition(transition)
	
	await tsm.mid_transition_signal
	
	$CurrentSceneStack.get_child(0).queue_free()
	var instance = menu_end_game.instantiate()
	$CurrentSceneStack.add_child(instance)
	if instance.has_method("set_default_focus"):
		instance.set_default_focus()
	
	
func _on_mid_open_main_menu():	
	$CurrentSceneStack.get_child(0).queue_free()
	var instance = menu_main.instantiate()
	$CurrentSceneStack.add_child(instance)
	if instance.has_method("set_default_focus"):
		instance.set_default_focus()
	
func open_menu(menu:MENU_TYPE):
	var currect_scene_path = $CurrentSceneStack.get_child(0).scene_file_path
	if currect_scene_path == menu_main.resource_path:
		match menu:
			MENU_TYPE.CREDITS:
				current_transition = Transition_to.Credits
			MENU_TYPE.CONTROLS:
				current_transition = Transition_to.Controls
				
		tsm.start_transition(transition)
		
func  _on_mid_open_menu():
	var node = null
	match current_transition:
		Transition_to.Controls:
			node = menu_controls.instantiate()
		Transition_to.Credits:
			node = menu_credits.instantiate()
		
	if node:
		$CurrentSceneStack.add_child(node)
		if node.has_method("set_default_focus"):
			node.set_default_focus()
	
func close_menu():
	current_transition = Transition_to.CloseMenu
	tsm.start_transition(transition)
	
func _on_mid_transition():
	if current_transition != Transition_to.None:
		tsm.end_transition()
	
	if current_transition == Transition_to.Level:
		var first_in_stack = $CurrentSceneStack.get_child(0)
		first_in_stack.queue_free()
		first_in_stack.reparent(self)
		var scene_node:Node = load(next_scene).instantiate()
		$CurrentSceneStack.add_child(scene_node)
		
	elif current_transition == Transition_to.MainMenu:
		_on_mid_open_main_menu()
	elif current_transition in [Transition_to.Credits, Transition_to.Controls]:
		_on_mid_open_menu()
	elif current_transition == Transition_to.CloseMenu and $CurrentSceneStack.get_child_count() > 1:
		var node:Control = $CurrentSceneStack.get_children().back()
		node.reparent(self)
		node.queue_free()
		
		var current_menu = $CurrentSceneStack.get_children().back()
		if current_menu != null and current_menu.has_method("set_default_focus"):
			current_menu.set_default_focus()

func _on_end_transition():
	if current_transition != Transition_to.None:
		next_scene = null
		pause(false)
		open_level_end_signal.emit()
		current_transition = Transition_to.None
		
		
		
func is_open_any_menu():
	return (current_transition != Transition_to.Level and \
	$CurrentSceneStack.get_children().back().is_in_group("menu")) or \
	current_transition in [Transition_to.MainMenu, Transition_to.Credits, Transition_to.Controls, Transition_to.CloseMenu, Transition_to.EndGame]
	

func _input(event: InputEvent) -> void: 
	if event.is_action_pressed("pause"):
		if not is_open_any_menu():
			pause(not get_tree().paused)
		
func pause(new_value:bool = false):
	get_tree().paused = new_value
	pause_signal.emit()
	
func get_transitionManager() -> TransitionManagerClass:
	return tsm
