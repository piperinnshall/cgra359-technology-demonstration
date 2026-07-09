extends Control

signal play_pressed
signal quit_pressed

@onready var play_button := $VBoxContainer/Play
@onready var quit_button := $VBoxContainer/Quit

func _ready():
    play_button.pressed.connect(_on_play_pressed)
    quit_button.pressed.connect(_on_quit_pressed)
    
func _on_play_pressed():
    play_pressed.emit()
    
func _on_quit_pressed():
    quit_pressed.emit()
