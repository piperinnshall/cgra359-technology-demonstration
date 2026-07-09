extends Node
class_name GameCoordinator

const START_LEVEL := "res://src/scenes/levels/level_demo.tscn"

var _scene_coordinator: SceneCoordinator

func setup(scene_coordinator: SceneCoordinator):
    _scene_coordinator = scene_coordinator

func quit():
    get_tree().quit()
