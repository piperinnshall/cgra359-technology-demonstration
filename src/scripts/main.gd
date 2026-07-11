extends Node

@onready var _game: GameCoordinator = $GameCoordinator
@onready var _scenes: ScenesCoordinator = $ScenesCoordinator
@onready var _ui: UICoordinator = $UICoordinator

func _ready() -> void:
    _ui.setup(_game)
    _game.setup(_scenes, _ui)
