extends Node

signal pause_pressed

func _unhandled_input(event):
    if event.is_action_pressed("game_pause"):
        print("game_pause")
        pause_pressed.emit()
