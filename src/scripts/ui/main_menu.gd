extends Control

signal play_pressed
signal quit_pressed

@onready var _play_button   := $VBoxContainer/Play
@onready var _quit_button   := $VBoxContainer/Quit

func _ready():
    _play_button.pressed.connect(_on_play_pressed)
    _quit_button.pressed.connect(_on_quit_pressed)
    
func _on_play_pressed():
    play_pressed.emit()
    
func _on_quit_pressed():
    quit_pressed.emit()
