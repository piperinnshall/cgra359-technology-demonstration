extends CharacterBody3D

const MAX_MOUSE_DELTA := 50.0

@export var sensitivity := 0.005

@export_category("Movement")
@export var speed := 4.0
@export var acceleration := 60.0
@export var jump_velocity := 4.5
@export var air_control := 5.0
@export var air_drag := 2.0

@onready var pivot: Node3D = $Pivot
@onready var camera: Camera3D = $Pivot/Camera

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        # Clamp unusually large mouse deltas to prevent sudden camera flips.
        var dx := clampf(event.relative.x, -MAX_MOUSE_DELTA, MAX_MOUSE_DELTA)
        var dy := clampf(event.relative.y, -MAX_MOUSE_DELTA, MAX_MOUSE_DELTA)
        pivot.rotate_y(-dx * sensitivity)
        camera.rotate_x(-dy * sensitivity)
        camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
    var grounded := is_on_floor()
    
    if not grounded: 
        velocity += get_gravity() * delta
    
    if grounded and Input.is_action_just_pressed("player_jump"):
        velocity.y = jump_velocity
        
    var input := Input.get_vector("player_left", "player_right", "player_forward", "player_back")
    var direction := (pivot.transform.basis * Vector3(input.x, 0, input.y)).normalized()
    var target_velocity := direction * speed
    var h_velocity := Vector3(velocity.x, 0, velocity.z)
    
    var control := acceleration if grounded else air_drag
    h_velocity = h_velocity.move_toward(target_velocity, control * delta)
    
    if not grounded and direction:
        h_velocity = h_velocity.move_toward(target_velocity, air_control * delta)
        
    velocity.x = h_velocity.x
    velocity.z = h_velocity.z
    move_and_slide()
