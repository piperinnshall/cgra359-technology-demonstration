extends Node
class_name GameCoordinator

const UIState := UICoordinator.State
const START_LEVEL := "res://src/scenes/levels/level_demo.tscn"

var _scene_coordinator: SceneCoordinator
var _ui_coordinator: UICoordinator

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    InputManager.pause_pressed.connect(_pause)
    InputManager.debug_pressed.connect(_debug)
    
func setup(scene_coordinator: SceneCoordinator, ui_coordinator: UICoordinator) -> void:
    _scene_coordinator = scene_coordinator
    _ui_coordinator = ui_coordinator
    _ui_coordinator.change(UIState.MAIN_MENU)

func play() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    _ui_coordinator.change(UIState.NONE)
    _scene_coordinator.change(
        START_LEVEL, 
        func(): _ui_coordinator.change(UIState.HUD)
    )
    
func quit() -> void:
    get_tree().quit()

func _pause() -> void:
    if _ui_coordinator.state != UIState.HUD and _ui_coordinator.state != UIState.PAUSE_MENU:
        return

    var paused = _ui_coordinator.state == UIState.PAUSE_MENU
    var change = UIState.HUD if paused else UIState.PAUSE_MENU
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if paused else Input.MOUSE_MODE_VISIBLE
    get_tree().paused = paused
    _ui_coordinator.change(change)
    
func _debug() -> void:
    _ui_coordinator.debug()
