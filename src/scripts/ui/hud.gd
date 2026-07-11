extends Control

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    $Cursor.mouse_filter = Control.MOUSE_FILTER_IGNORE
    visible = false
