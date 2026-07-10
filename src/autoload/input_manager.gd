extends Node

signal pause_pressed

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    
func _unhandled_input(event) -> void:
    if event.is_action_pressed("game_pause"):
        pause_pressed.emit()
