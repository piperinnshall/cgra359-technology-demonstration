extends CanvasLayer

enum State {
    MAIN_MENU,
    PAUSE_MENU,
}

@onready var ui := {
    State.MAIN_MENU: $MainMenu,
    #State.PAUSE_MENU: $PauseMenu,
}

var state: State

func _ready():
    change(State.MAIN_MENU)

func change(new_state: State):
    if state == new_state: 
        return
    if state != null:
        ui[state].hide()
        
    ui[new_state].show()
    state = new_state
    
