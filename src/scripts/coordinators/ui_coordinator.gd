extends CanvasLayer
class_name UICoordinator

enum State {
    MAIN_MENU,
    PAUSE_MENU,
    HUD,
}

var _game_coordinator: GameCoordinator
var state := State.MAIN_MENU

@onready var _debug_menu := $DebugMenu
@onready var _hud := $HUD
@onready var _main_menu := $MainMenu
@onready var _pause_menu := $PauseMenu
@onready var _ui := {
    State.HUD: _hud,
    State.MAIN_MENU: _main_menu,
    State.PAUSE_MENU: _pause_menu,
}

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS

func setup(game_coordinator: GameCoordinator):
    _game_coordinator = game_coordinator
    _main_menu.play_pressed.connect(_on_play_pressed)
    _main_menu.quit_pressed.connect(_on_quit_pressed)

func change(new_state: State) -> void:
    if state == new_state: 
        return
    _ui[state].hide()
    _ui[new_state].show()
    state = new_state
    
func debug() -> void:
    _debug_menu.visible = !_debug_menu.visible
        
func _on_play_pressed() -> void: 
    _game_coordinator.on_play_pressed()
    
func _on_quit_pressed() -> void: 
    _game_coordinator.on_quit_pressed()
