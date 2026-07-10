extends Node
class_name SceneCoordinator

var _current_scene: Node3D
var _loading_path := ""
var _loading_callable: Callable

func change(path: String, callable: Callable) -> void:
    if _loading_path: 
        return
        
    var err := ResourceLoader.load_threaded_request(path)
    if err != OK:
        push_error("Failed to start loading: " + path)
        return
        
    _loading_path = path
    _loading_callable = callable
    set_process(true)

func _process(_delta: float) -> void:
    if not _loading_path: 
        return
        
    var status := ResourceLoader.load_threaded_get_status(_loading_path)
    match status:
        ResourceLoader.THREAD_LOAD_LOADED:
            var scene := ResourceLoader.load_threaded_get(_loading_path)
            if scene:
                _change(scene)
            else: 
                push_error("Loaded resource is not a PackedScene: " + _loading_path)
            _stop_loading()
        ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
            push_error("Failed to load scene: " + _loading_path)
            _stop_loading()

func _stop_loading() -> void:
    _loading_path = ""
    _loading_callable = Callable()
    set_process(false)

func _change(scene: PackedScene) -> void:
    if _current_scene:
        _current_scene.queue_free()
        
    var instance := scene.instantiate()
    get_tree().root.add_child(instance)
    _current_scene = instance
    
    if _loading_callable.is_valid():
        _loading_callable.call()
       
    
