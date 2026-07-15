extends Node
class_name GameCoordinator

const UIState := UICoordinator.State 

var _world: WorldCoordinator
var _ui: UICoordinator

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    InputManager.pause_pressed.connect(_on_pause_pressed)
    InputManager.debug_pressed.connect(_on_debug_pressed)
    
func setup(ui: UICoordinator, world: WorldCoordinator) -> void:
    _ui = ui
    _world = world
    
func _on_pause_pressed() -> void:
    if _ui.state != UIState.HUD and _ui.state != UIState.PAUSE_MENU:
        return

    var paused = _ui.state == UIState.PAUSE_MENU
    var new_state = UIState.HUD if paused else UIState.PAUSE_MENU
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if paused else Input.MOUSE_MODE_VISIBLE
    get_tree().paused = not paused
    _ui.change(new_state)
    
func _on_debug_pressed() -> void:
    _ui.debug()
    
func on_play_pressed() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    _world.change(
        WorldCoordinator.Level.START,
        func(): _ui.change(UIState.HUD)
    )

func on_quit_pressed() -> void:
    get_tree().quit()
