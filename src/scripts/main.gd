extends Node

@onready var _game_coordinator  := $GameCoordinator
@onready var _scene_coordinator := $SceneCoordinator
@onready var _ui_coordinator    := $UICoordinator

func _ready() -> void:
    _ui_coordinator.setup(_game_coordinator)
    _game_coordinator.setup(_scene_coordinator, _ui_coordinator)
