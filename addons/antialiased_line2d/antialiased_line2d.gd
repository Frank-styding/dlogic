@tool
@icon("antialiased_line2d.svg")
class_name AntialiasedLine2D
extends Line2D




func _ready() -> void:
	texture = AntialiasedLine2DTexture.texture
	texture_mode = Line2D.LINE_TEXTURE_TILE
	texture_filter = TextureFilter.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	
