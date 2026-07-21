extends Node
class_name GravityManager

var _player: Player
var _gravity_zones: Array[GravityZone]
var _active_zone: GravityZone = null

func setup(player: Player) -> void:
    _player = player

func set_zones(zones: Array[GravityZone]) -> void:
    _gravity_zones = zones
    # for zone in _gravity_zones:
        #zone.player_entered.connect(_on_zone_entered)
        # zone.player_exited.connect(_on_zone_exited)

func player_flip() -> void:
    if _player == null:
        return
    if not _player.is_on_floor():
        return
    if not _player.can_flip():
        return
    if _active_zone != null:
        return
        
    _player.lock()
    var new_gravity_dir := _calculate_gravity_direction()
    var current_gravity_dir := -_player.up_direction
    if new_gravity_dir.is_equal_approx(current_gravity_dir):
        _player.unlock()
        return
    _player.set_gravity_direction(new_gravity_dir)
    _player.unlock()

func _calculate_gravity_direction() -> Vector3:
    var forward := -_player.camera.global_transform.basis.z
    return _snap_to_cardinal(forward)

func _snap_to_cardinal(v: Vector3) -> Vector3:
    var a := v.abs()
    if a.x >= a.y and a.x >= a.z:
        return Vector3(signf(v.x), 0, 0)
    if a.y >= a.x and a.y >= a.z:
        return Vector3(0, signf(v.y), 0)
    return Vector3(0, 0, signf(v.z))
