@tool
extends Panel


@onready var tile = $Tile as Panel

var background_box = StyleBoxFlat.new()
var tile_box = StyleBoxFlat.new()

@export_group("Style")
@export_color_no_alpha var background_color: Color:
	set(value):
		background_box.bg_color = value
		background_color = value
		
@export_color_no_alpha var tile_color:Color:
	set(value):
		tile_box.bg_color = value
		tile_color = value

@export var margin:int:
	set(value):
		margin = value
		if not tile:
			return
		tile.set_size(Vector2i(cell_size,cell_size) - Vector2i(value,value)*2)
		tile.position = Vector2i(value,value)
		
@export var border:int:
	set(value):
		tile_box.set_corner_radius_all(value)
		border = value

var cell_size = 100;

func _ready():
	background_box.bg_color = background_color
	tile_box.bg_color = tile_color
	tile_box.set_corner_radius_all(border)
	#tile_box.set_border_width_all(4)
	tile.set_size(Vector2i(cell_size,cell_size) - Vector2i(margin,margin)*2)
	tile.position = Vector2i(margin,margin)
	
	tile.set("theme_override_styles/panel",tile_box)
	self.set("theme_override_styles/panel",background_box)
	
	
	#cell_size = GridData.cell_size
	#set_size(Vector2(1,1) * GridData.cell_size)
