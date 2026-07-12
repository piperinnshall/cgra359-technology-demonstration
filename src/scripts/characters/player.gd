extends CharacterBody3D

const MAX_MOUSE_DELTA := 50.0
@export var sensitivity := 0.005

@export_category("Movement")
@export var speed := 4.0
@export var acceleration := 60.0
@export var jump_velocity := 4.5
@export var air_control := 5.0
@export var air_drag := 2.0

@export_category("Gravity")
# How fast the body slerps into its new orientation. Higher = snappier.
@export var orientation_lerp_speed := 8.0
@export var gravity_strength := 9.8

@onready var pivot: Node3D = $Pivot
@onready var camera: Camera3D = $Pivot/Camera

# The orientation we're rotating toward.
var target_orientation := Quaternion.IDENTITY


func _ready() -> void:
    up_direction = global_transform.basis.y
    target_orientation = Quaternion(global_transform.basis.orthonormalized())


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        var dx := clampf(event.relative.x, -MAX_MOUSE_DELTA, MAX_MOUSE_DELTA)
        var dy := clampf(event.relative.y, -MAX_MOUSE_DELTA, MAX_MOUSE_DELTA)
        pivot.rotate_y(-dx * sensitivity)
        camera.rotate_x(-dy * sensitivity)
        camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _physics_process(delta: float) -> void:
    _update_orientation(delta)

    up_direction = global_transform.basis.y.normalized()
    var up := up_direction
    var gravity_dir := -up

    var grounded := is_on_floor()

    var vertical_velocity := velocity.project(up)
    var horizontal_velocity := velocity - vertical_velocity

    if not grounded:
        vertical_velocity += gravity_dir * gravity_strength * delta

    if grounded and Input.is_action_just_pressed("player_jump"):
        vertical_velocity = up * jump_velocity

    if grounded and Input.is_action_just_pressed("gravity_switch"):
        _try_switch_gravity()

    var input := Input.get_vector("player_left", "player_right", "player_forward", "player_back")
    var pivot_basis := pivot.global_transform.basis
    var direction := (pivot_basis * Vector3(input.x, 0, input.y))
    if direction.length() > 0.0001:
        direction = (direction - direction.project(up)).normalized()
    var target_velocity := direction * speed

    var control := acceleration if grounded else air_drag
    horizontal_velocity = horizontal_velocity.move_toward(target_velocity, control * delta)

    if not grounded and direction.length() > 0.0001:
        horizontal_velocity = horizontal_velocity.move_toward(target_velocity, air_control * delta)

    velocity = horizontal_velocity + vertical_velocity
    move_and_slide()

func _update_orientation(delta: float) -> void:
    var current := Quaternion(global_transform.basis.orthonormalized())
    if current.is_equal_approx(target_orientation):
        return
    var t := clampf(orientation_lerp_speed * delta, 0.0, 1.0)
    var new_quat := current.slerp(target_orientation, t).normalized()
    global_transform.basis = Basis(new_quat).orthonormalized()

func _try_switch_gravity() -> void:
    var forward := -camera.global_transform.basis.z
    var new_gravity_dir := _snap_to_cardinal(forward)

    var current_up := global_transform.basis.y.normalized()
    var current_gravity_dir := -current_up

    if new_gravity_dir.is_equal_approx(current_gravity_dir):
        return

    var new_up := -new_gravity_dir

    var roll_axis := -camera.global_transform.basis.z
    roll_axis = roll_axis.slide(current_up).normalized()

    var delta_rotation := _rotation_between(
        current_up,
        new_up,
        roll_axis
    )

    var current_quat := Quaternion(global_transform.basis.orthonormalized())
    target_orientation = (delta_rotation * current_quat).normalized()


func _rotation_between(from: Vector3, to: Vector3, preferred_axis: Vector3) -> Quaternion:
    var dot := from.dot(to)

    # Opposite directions require manually choosing the rotation axis.
    if dot < -0.9999:
        var axis := preferred_axis.normalized()
        return Quaternion(axis, PI)

    return Quaternion(from, to)

func _snap_to_cardinal(v: Vector3) -> Vector3:
    var a := v.abs()
    if a.x >= a.y and a.x >= a.z:
        return Vector3(signf(v.x), 0, 0)
    elif a.y >= a.x and a.y >= a.z:
        return Vector3(0, signf(v.y), 0)
    else:
        return Vector3(0, 0, signf(v.z))
