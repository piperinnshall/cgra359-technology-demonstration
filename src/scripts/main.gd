extends Node

@onready var _game: GameCoordinator = $GameCoordinator
@onready var _scenes: ScenesCoordinator = $ScenesCoordinator
@onready var _ui: UICoordinator = $UICoordinator
@onready var _world: WorldCoordinator = $WorldCoordinator

func _ready() -> void:
    _world.setup(_scenes)
    _ui.setup(_game)
    _game.setup(_ui, _world)
