extends CanvasLayer
class_name UICoordinator

enum State {
    MAIN_MENU,
    PAUSE_MENU,
    NONE,
}

var _game_coordinator: GameCoordinator
var _state := State.NONE

@onready var _main_menu := $MainMenu
@onready var _pause_menu := $PauseMenu
@onready var _ui := {
    State.MAIN_MENU: _main_menu,
    State.PAUSE_MENU: _pause_menu,
}

func setup(game_coordinator: GameCoordinator):
    _game_coordinator = game_coordinator
    _main_menu.play_pressed.connect(_on_play_pressed)
    _main_menu.quit_pressed.connect(_on_quit_pressed)
    _change(State.MAIN_MENU)

func _change(new_state: State):
    if _state == new_state: 
        return
    if _state != State.NONE:
        _ui[_state].hide()
        
    _ui[new_state].show()
    _state = new_state
    
func _on_play_pressed(): 
    pass
    
func _on_quit_pressed(): 
    _game_coordinator.quit()
