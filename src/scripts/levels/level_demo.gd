extends Node3D

@export var gravity_zones: Array[GravityZone]

var _player: Player

@onready var player_spawn: Marker3D = $PlayerSpawn
@onready var death_box: Area3D = $DeathBox

func _ready() -> void:
    death_box.body_entered.connect(_on_death_box_entered)

func setup(player: Player) -> void:
    _player = player
    _player.position = player_spawn.position
    _player.rotation = player_spawn.rotation

func zones() -> Array[GravityZone]:
    return gravity_zones

func _physics_process(_delta: float) -> void:
    if _player == null:
        return
        
func _on_death_box_entered(body: Node) -> void:
    if body is Player:
        _player.global_position = Vector3(0.0, 1.5, 0.0)
        _player.velocity = Vector3.ZERO
