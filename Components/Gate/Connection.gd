@tool
class_name GateConnection
extends Panel

signal mouse_click(data:Dictionary)
signal mouse_unclick(data:Dictionary)


var box = StyleBoxFlat.new()
var _max
var _min

@onready var label = $CenterContainer/Label as Label;
@onready var center_container = $CenterContainer

@export_color_no_alpha var color:Color = Color.hex(0x000000ff):
	set(value):
		box.bg_color = value
		color = value
		
@export var border_radius: int :
	set(value):
		box.set_corner_radius_all(value)
		border_radius = value

@export var real_size: Vector2:
	set(value):
		_max = value.x
		_min = value.y
		var _size = Vector2(_max,_min)
		set_size(_size)
		set("custom_minimum_size",_size)
		real_size = value
	

var data:Dictionary
var direction:int
func _ready():
	set_size(Vector2(_max,_min))
	self.set("theme_override_styles/panel",box)
	
	if data:
		set_connection_name(data["name"])
		rotate_for_position(direction)


func set_connection_name(_name:String):
	if label == null:
		return
	label.text = _name
	
func rotate_for_position(_position:int):
	if not center_container:
		return
		
	# update size of connection and text container
	var _size;
	if _position % 2 == 0:
		_size = Vector2(_max,_min)
	elif _position % 2 == 1:
		_size = Vector2(_min,_max)	
	set("custom_minimum_size",_size)
	set_size(_size)	
	position = -size/2
	center_container.set_size(Vector2(_max,_min))
	
	# rotate text
	center_container.pivot_offset = size/2
	center_container.rotation = -PI/2 * _position
	center_container.pivot_offset = Vector2(0,0)
	
	
	## fix_position of text
	var _diff = (center_container.size.y - _min)/2
	if _position == 0:
		center_container.position=Vector2(0,-_diff)
	elif _position == 1:
		center_container.position = Vector2(-_diff,_max)
	elif _position == 2:
		center_container.position = Vector2(_max,_min + _diff)
	elif _position == 3:
		center_container.position = Vector2(_min+_diff,0)


func set_data(_direction:int,_data:Dictionary):
	data = _data
	direction = _direction
	


var mouse_inside = false
var first_click = true

func _on_mouse_entered():
	mouse_inside = true
	
func _on_mouse_exited():
	mouse_inside = false
	
func _input(event):
	if not mouse_inside:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and first_click:
			mouse_click.emit(data)
			first_click = false
		else:
			if not first_click:
				mouse_unclick.emit(data)
			first_click = true


