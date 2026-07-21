extends Control

var _player_can_rotate := false

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    visible = false

func _process(_delta: float) -> void:
    modulate = Color.GREEN if _player_can_rotate else Color.RED

func update(player_can_rotate: bool) -> void:
    _player_can_rotate = player_can_rotate
