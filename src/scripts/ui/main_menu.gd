extends Control

signal play_pressed
signal quit_pressed

func _on_play_pressed():
    play_pressed.emit()
func _on_quit_pressed():
    quit_pressed.emit()
