extends Node3D
class_name WorldCoordinator

enum Level {
    START
}

const LEVEL_PATHS := {
    Level.START: "res://src/scenes/levels/level_demo.tscn",
}

var _scenes: ScenesCoordinator
var current_level: Node3D
var level := Level.START
var _change_callback: Callable

@onready var _player: Player = $Player
@onready var _gravity_manager: GravityManager = $GravityManager

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_PAUSABLE

func setup(scenes: ScenesCoordinator) -> void:
    _scenes = scenes
    _gravity_manager.setup(_player)
    _player.setup(_gravity_manager)

func change(new_level: Level, callback: Callable = Callable()) -> void:
    if not LEVEL_PATHS.has(new_level):
        push_error("Unknown level")
        return

    level = new_level
    _change_callback = callback

    _scenes.load_scene(
        LEVEL_PATHS[new_level],
        _on_level_loaded
    )

func _on_level_loaded(scene: PackedScene) -> void:
    if current_level:
        current_level.queue_free()

    current_level = scene.instantiate()
    add_child(current_level)

    if current_level.has_method("setup"):
        current_level.setup(_player)

    if _change_callback.is_valid():
        _change_callback.call()
    _change_callback = Callable()
    
# --------------------------------------------------

func player_can_rotate() -> bool:
    return _player.is_on_floor() and _player.can_rotate
