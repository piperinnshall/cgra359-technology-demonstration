extends Node

@onready var ui_coordinator     := $UICoordinator
@onready var game_coordinator   := $GameCoordinator

func _ready() -> void:
    ui_coordinator.game_coordinator = game_coordinator
