extends Node
class_name ScenesCoordinator

var _loading_path := ""
var _loading_callable: Callable


func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS


func load_scene(path: String, callback: Callable) -> void:
    if _loading_path:
        return

    var err := ResourceLoader.load_threaded_request(path)
    if err != OK:
        push_error("Failed to start loading: " + path)
        return

    _loading_path = path
    _loading_callable = callback
    set_process(true)


func _process(_delta: float) -> void:
    if not _loading_path:
        return

    var status := ResourceLoader.load_threaded_get_status(_loading_path)

    match status:
        ResourceLoader.THREAD_LOAD_LOADED:
            var scene := ResourceLoader.load_threaded_get(_loading_path)

            if scene is PackedScene:
                _loading_callable.call(scene)
            else:
                push_error("Not a PackedScene: " + _loading_path)

            _stop_loading()

        ResourceLoader.THREAD_LOAD_FAILED:
            push_error("Failed loading: " + _loading_path)
            _stop_loading()


func _stop_loading() -> void:
    _loading_path = ""
    _loading_callable = Callable()
    set_process(false)
