extends CanvasLayer
class_name UICoordinator

enum State {
    MAIN_MENU,
    PAUSE_MENU,
    HUD,
    NONE,
}

var state := State.NONE
var _game_coordinator: GameCoordinator

@onready var _hud := $HeadsUpDisplay
@onready var _main_menu := $MainMenu
@onready var _pause_menu := $PauseMenu
@onready var _ui := {
    State.MAIN_MENU: _main_menu,
    State.PAUSE_MENU: _pause_menu,
    State.HUD: _hud,
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
        
    if state != State.NONE:
        _ui[state].hide()
        
    if new_state != State.NONE:
        _ui[new_state].show()
        
    state = new_state
        
func _on_play_pressed() -> void: 
    _game_coordinator.play()
    
func _on_quit_pressed() -> void: 
    _game_coordinator.quit()
