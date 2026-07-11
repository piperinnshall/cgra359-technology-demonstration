@tool
extends CSGBox3D

enum BoxColor {
    DARK, 
    GREEN,
    LIGHT, 
    ORANGE,
    PURPLE,
    RED,
}

enum BoxTexture {
    TEXTURE_01,
    TEXTURE_02,
    TEXTURE_03,
    TEXTURE_04,
    TEXTURE_05,
    TEXTURE_06,
    TEXTURE_07,
    TEXTURE_08,
    TEXTURE_09,
    TEXTURE_10,
    TEXTURE_11,
    TEXTURE_12,
    TEXTURE_13,
}

const COLORS := {
    BoxColor.DARK: "dark",
    BoxColor.GREEN: "green",
    BoxColor.LIGHT: "light",
    BoxColor.ORANGE: "orange",
    BoxColor.PURPLE: "purple",
    BoxColor.RED: "red",
}

@export var color := BoxColor.DARK:
    set(value):
        color = value
        _update_material()
        
@export var texture := BoxTexture.TEXTURE_01:
    set(value):
        texture = value
        _update_material()
      

func _ready() -> void:
    _update_material()
    
    

func _update_material() -> void:
    var color_folder = COLORS[color]
    var texture_number := texture + 1
    var path := "res://assets/art/third-party/prototype-textures/png/%s/texture_%02d.png" % [
        color_folder,
        texture_number
    ]
    
    var new_material := StandardMaterial3D.new()
    new_material.albedo_texture = load(path)
    new_material.uv1_scale = Vector3(1, -1, 1)
    new_material.uv1_triplanar = true
    new_material.uv1_world_triplanar = true
    material = new_material
