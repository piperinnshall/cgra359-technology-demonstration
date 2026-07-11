extends Node
class_name GameCoordinator

const UIState := UICoordinator.State
const START_LEVEL := "res://src/scenes/levels/level_demo.tscn"

var _scene_coordinator: SceneCoordinator
var _ui_coordinator: UICoordinator

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    InputManager.pause_pressed.connect(_on_pause_pressed)
    InputManager.debug_pressed.connect(_on_debug_pressed)
    
func setup(scene_coordinator: SceneCoordinator, ui_coordinator: UICoordinator) -> void:
    _scene_coordinator = scene_coordinator
    _ui_coordinator = ui_coordinator
    
func _on_pause_pressed() -> void:
    if _ui_coordinator.state != UIState.HUD and _ui_coordinator.state != UIState.PAUSE_MENU:
        return

    var paused = _ui_coordinator.state == UIState.PAUSE_MENU
    var new_state = UIState.HUD if paused else UIState.PAUSE_MENU
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if paused else Input.MOUSE_MODE_VISIBLE
    get_tree().paused = not paused
    _ui_coordinator.change(new_state)
    
func _on_debug_pressed() -> void:
    _ui_coordinator.debug()
    
func on_play_pressed() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    _scene_coordinator.change(
        START_LEVEL, 
        func(): 
            _ui_coordinator.change(UIState.HUD)
    )

func on_quit_pressed() -> void:
    get_tree().quit()
