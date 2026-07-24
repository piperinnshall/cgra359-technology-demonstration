extends Node
class_name GravityManager

var _player: Player
var _gravity_zones: Array[GravityZone] = []
var _active_zone: GravityZone = null

func setup(player: Player) -> void:
    _player = player

func set_zones(zones: Array[GravityZone]) -> void:
    _gravity_zones = zones

    for zone in _gravity_zones:
        zone.player_entered.connect(_on_zone_entered)
        zone.player_exited.connect(_on_zone_exited)

func _process(_delta: float) -> void:
    if _player == null:
        return

    if _active_zone == null:
        return

    var gravity_dir := _active_zone.get_gravity_direction(
        _player.global_position
    )

    var current_gravity := -_player.up_direction

    # Avoid constantly updating the player gravity when the direction has not meaningfully changed.
    if gravity_dir.angle_to(current_gravity) > 0.001:
        _player.set_zone_gravity_direction(gravity_dir)

func player_flip() -> void:
    if _player == null:
        return
    if not _player.is_on_floor():
        return
    if not _player.can_flip():
        return
    if _active_zone != null:
        return

    var new_gravity_dir := _calculate_gravity_direction()
    var current_gravity_dir := -_player.up_direction

    if new_gravity_dir.is_equal_approx(current_gravity_dir):
        return

    # Locking prevents movement/input conflicts while the player's orientation is being changed.
    _player.lock()
    _player.set_gravity_direction(new_gravity_dir)
    _player.unlock()


func _calculate_gravity_direction() -> Vector3:
    var forward := -_player.camera.global_transform.basis.z
    return _snap_to_cardinal(forward)


func _snap_to_cardinal(v: Vector3) -> Vector3:
    var a := v.abs()

    # Gravity is restricted to the six cardinal directions so rotations stay predictable.
    if a.x >= a.y and a.x >= a.z:
        return Vector3(signf(v.x), 0, 0)

    if a.y >= a.x and a.y >= a.z:
        return Vector3(0, signf(v.y), 0)

    return Vector3(0, 0, signf(v.z))


func is_in_gravity_zone() -> bool:
    return _active_zone != null


func _on_zone_entered(zone: GravityZone) -> void:
    _active_zone = zone

func _on_zone_exited(zone: GravityZone) -> void:
    if _active_zone == zone:
        _active_zone = null

        var current_gravity := -_player.up_direction
        var snap_direction := _snap_to_cardinal(current_gravity)

        _player.set_zone_gravity_direction(snap_direction)
