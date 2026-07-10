extends Node
class_name SceneCoordinator

var _current_scene: Node3D
var _loading_callable: Callable
var _loading_path := ""

func change(path: String, callable: Callable) -> void:
    if _loading_path: 
        return
    ResourceLoader.load_threaded_request(path)
    _loading_path = path
    _loading_callable = callable
    set_process(true)

func _process(_delta: float) -> void:
    if not _loading_path: 
        return
    match ResourceLoader.load_threaded_get_status(_loading_path):
        ResourceLoader.THREAD_LOAD_LOADED:
            var scene := ResourceLoader.load_threaded_get(_loading_path)
            _change(scene)
            _stop_loading()
        ResourceLoader.THREAD_LOAD_FAILED:
            push_error("Failed to load scene: " + _loading_path)
            _stop_loading()

func _stop_loading() -> void:
    _loading_path = ""
    set_process(false)

func _change(scene: PackedScene) -> void:
    if _current_scene:
        _current_scene.queue_free()
        
    var instance := scene.instantiate()
    get_tree().root.add_child(instance)
    _current_scene = instance
    
    if _loading_callable.is_valid():
        _loading_callable.call()
