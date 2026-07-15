extends Node3D

var _player: Player

@onready var player_spawn: Marker3D = $PlayerSpawn
@onready var death_box: Area3D = $DeathBox

func _ready() -> void:
    death_box.body_entered.connect(_on_body_entered)
    
func setup(player: Player) -> void:
    _player = player
    _player.position = player_spawn.position
    _player.rotation = player_spawn.rotation

func _on_body_entered(body: Node) -> void:
    if body == _player:
        _player.global_position = Vector3(0.0, 1.5, 0.0)
        _player.velocity = Vector3.ZERO
