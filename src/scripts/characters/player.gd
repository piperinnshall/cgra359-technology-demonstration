extends CharacterBody3D
class_name Player

const MAX_MOUSE_DELTA := 50.0

@export var sensitivity := 0.005
@export_category("Movement")
@export var speed := 4.0
@export var acceleration := 60.0
@export var jump_velocity := 4.5
@export var air_drag := 2.0
@export_category("Gravity")
@export var gravity_strength := 9.8

var _gravity_manager: GravityManager
var _locked := false

@onready var pivot: Node3D = $Pivot
@onready var camera: Camera3D = $Pivot/Camera


func _ready() -> void:
    up_direction = global_transform.basis.y


func setup(gravity_manager: GravityManager) -> void:
    _gravity_manager = gravity_manager


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        var dx := clampf(event.relative.x, -MAX_MOUSE_DELTA, MAX_MOUSE_DELTA)
        var dy := clampf(event.relative.y, -MAX_MOUSE_DELTA, MAX_MOUSE_DELTA)

        pivot.rotate_y(-dx * sensitivity)
        camera.rotate_x(-dy * sensitivity)
        camera.rotation.x = clampf(
            camera.rotation.x,
            deg_to_rad(-90),
            deg_to_rad(90)
        )


func _physics_process(delta: float) -> void:
    if _locked:
        return

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
        _gravity_manager.player_flip()

    var input := Input.get_vector(
        "player_left",
        "player_right",
        "player_forward",
        "player_back"
    )

    var pivot_basis := pivot.global_transform.basis
    var direction := pivot_basis * Vector3(input.x, 0, input.y)

    if direction.length() > 0.0001:
        direction = (direction - direction.project(up)).normalized()

    var target_velocity := direction * speed

    if grounded:
        horizontal_velocity = horizontal_velocity.move_toward(
            target_velocity,
            acceleration * delta
        )

    velocity = horizontal_velocity + vertical_velocity

    move_and_slide()


func lock() -> void:
    velocity = Vector3.ZERO
    _locked = true

func unlock() -> void:
    _locked = false

func set_gravity_direction(gravity_direction: Vector3) -> void:
    var new_up := -gravity_direction
    var current_up := global_transform.basis.y.normalized()
    
    var roll_axis := -camera.global_transform.basis.z
    roll_axis = roll_axis.slide(current_up).normalized()
    
    var delta_rotation := _rotation_between(current_up, new_up, roll_axis)
    var current_quat := Quaternion(global_transform.basis.orthonormalized())
    global_transform.basis = Basis((delta_rotation * current_quat).normalized()).orthonormalized()
    
    up_direction = new_up

func _rotation_between(from: Vector3, to: Vector3, preferred_axis: Vector3) -> Quaternion:
    var dot := from.dot(to)
    if dot < -0.9999:
        var axis := preferred_axis.normalized()
        return Quaternion(axis, PI)
    return Quaternion(from, to)
