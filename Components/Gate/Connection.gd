@tool
class_name GateConnection
extends Panel

@onready var label = $CenterContainer/Label;

var box = StyleBoxFlat.new()

@export_color_no_alpha var color:Color = Color.hex(0x000000ff):
	set(value):
		box.bg_color = value
		color = value
		
@export var border_radius: int :
	set(value):
		box.set_corner_radius_all(value)
		border_radius = value
		
func _ready():
	self.set("theme_override_styles/panel",box)

	
func flip():
	var _size = Vector2(size.y,size.x)
	set_size(_size)

func set_connection_name(_name:String):
	label.set_name(_name)
	
	

