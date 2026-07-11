extends Control
class_name DebugOverlay

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    $Label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    visible = false
