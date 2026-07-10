extends Node
class_name GameCoordinator

const UIState := UICoordinator.State
const START_LEVEL := "res://src/scenes/levels/level_demo.tscn"

var _scene_coordinator: SceneCoordinator
var _ui_coordinator: UICoordinator

func setup(scene_coordinator: SceneCoordinator, ui_coordinator: UICoordinator):
    _scene_coordinator = scene_coordinator
    _ui_coordinator = ui_coordinator
    _ui_coordinator.change(UIState.MAIN_MENU)

func play():
    _ui_coordinator.change(UIState.NONE)
    _scene_coordinator.change(
        START_LEVEL, 
        func(): _ui_coordinator.change(UIState.HUD)
    )

func quit():
    get_tree().quit()
