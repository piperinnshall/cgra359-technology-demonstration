extends CanvasLayer
class_name UICoordinator


enum State {
    MAIN_MENU,
    PAUSE_MENU,
    NONE,
}

var game_coordinator: GameCoordinator
var state := State.NONE

@onready var ui := {
    State.MAIN_MENU: $MainMenu,
    #State.PAUSE_MENU: $PauseMenu,
}

func _ready():
    $MainMenu.play_pressed.connect(_on_play_pressed)
    $MainMenu.quit_pressed.connect(_on_quit_pressed)
    change(State.MAIN_MENU)

func change(new_state: State):
    if state == new_state: 
        return
    if state != State.NONE:
        ui[state].hide()
    ui[new_state].show()
    state = new_state
    
func _on_play_pressed(): 
    pass
    
func _on_quit_pressed(): 
    game_coordinator.quit()
