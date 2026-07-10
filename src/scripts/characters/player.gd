extends CharacterBody3D

@export var sensitivity := 0.005
@export var max_delta := 50.0
@export var jump_velocity = 4.5

@onready var head_pivot := $HeadPivot
@onready var camera := $HeadPivot/Camera

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        # Clamp unusually large mouse deltas to prevent sudden camera flips.
        var dx := clampf(event.relative.x, -max_delta, max_delta)
        var dy := clampf(event.relative.y, -max_delta, max_delta)
        head_pivot.rotate_y(-dx * sensitivity)
        camera.rotate_x(-dy * sensitivity)
        camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(90))

func _physics_process(delta: float) -> void:
    if not is_on_floor(): 
        velocity += get_gravity() * delta
    
    if Input.is_action_just_pressed("player_jump") and is_on_floor():
        velocity.y = jump_velocity
    
    move_and_slide()
