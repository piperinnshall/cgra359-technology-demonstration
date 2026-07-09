extends Node

@onready var _ui_coordinator     := $UICoordinator
@onready var _game_coordinator   := $GameCoordinator

func _ready() -> void:
    _ui_coordinator.game_coordinator = _game_coordinator
