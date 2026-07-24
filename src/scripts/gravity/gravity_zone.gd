extends Node3D
class_name GravityZone

signal player_entered(zone: GravityZone)
signal player_exited(zone: GravityZone)

enum Direction {
    PUSH,
    PULL,
}

@export var direction := Direction.PULL
@export var origin: Marker3D
@export var zone: Area3D

func _ready() -> void:
    zone.body_entered.connect(_on_body_entered)
    zone.body_exited.connect(_on_body_exited)

func get_gravity_direction(point: Vector3) -> Vector3:
    # Direction is calculated from the player toward the origin, creating a pull effect.
    var gravity := (origin.global_position - point).normalized()

    # Flipping the vector makes the zone push objects away from the origin instead.
    if direction == Direction.PUSH:
        gravity = -gravity

    return gravity

func _on_body_entered(body: Node3D) -> void:
    if body is Player:
        # The manager handles the actual gravity change; this zone only reports entry.
        player_entered.emit(self)

func _on_body_exited(body: Node3D) -> void:
    if body is Player:
        player_exited.emit(self)
