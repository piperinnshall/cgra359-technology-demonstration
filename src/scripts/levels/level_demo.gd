extends Node3D

const MOVEMENT := "res://assets/art/ui/movement.png"
const MOUSE1 := "res://assets/art/ui/mouse1.png"

var triggered := false

@onready var area := $Area3D
@onready var collider := $Area3D/CollisionShape3D

func _ready() -> void:
    await get_tree().create_timer(0.01).timeout
    await play_ui_animation(MOVEMENT)
    area.body_entered.connect(_on_body_entered)
    
func play_ui_animation(path: String, scale_img: float = 1.0) -> void:
    var tex := load(path) as Texture2D
    if tex == null:
        push_error("Failed to load: %s" % path)
        return

    var canvas := CanvasLayer.new()
    add_child(canvas)

    var image := TextureRect.new()
    image.texture = tex
    image.scale = Vector2.ONE * scale_img
    image.size = tex.get_size()
    image.position = (get_viewport().get_visible_rect().size - image.size * scale_img) / 2.0
    image.modulate.a = 0.0

    canvas.add_child(image)

    var tween := create_tween()
    tween.tween_property(image, "modulate:a", 1.0, 0.5)
    tween.tween_interval(0.7)
    tween.tween_property(image, "modulate:a", 0.0, 0.5)
    await tween.finished

    canvas.queue_free()

func _on_body_entered(_body: Node) -> void:
    if not triggered:
        await play_ui_animation(MOUSE1, 0.2)
        triggered = true
