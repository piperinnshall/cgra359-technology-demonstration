extends Node
class_name GameCoordinator

const START_LEVEL := "res://src/scenes/levels/level_demo.tscn"

var _scene_coordinator: SceneCoordinator

func setup(scene_coordinator: SceneCoordinator):
    _scene_coordinator = scene_coordinator

func play():
    _scene_coordinator.change_scene(START_LEVEL)

func quit():
    get_tree().quit()
