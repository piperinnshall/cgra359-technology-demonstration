extends Node

signal pause_pressed
signal debug_pressed

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_pause"):
		pause_pressed.emit()
	if event.is_action_pressed("game_debug"):
		debug_pressed.emit()
