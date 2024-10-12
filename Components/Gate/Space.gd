@tool
extends Panel
class_name ConnectionSpace

var _max = 0
var _min = 0

@export var real_size: Vector2:
	set(value):
		_max = value.x
		_min = value.y
		var _size = Vector2(_max,_min)
		set_size(_size)
		set("custom_minimum_size",_size)
		real_size = value
		
func set_direction(direction):
	var _size;
	if direction % 2 == 0:
		_size = Vector2(_max,_min)
	elif direction % 2 == 1:
		_size = Vector2(_min,_max)

	set("custom_minimum_size",_size)
	set_size(_size)
	position = -size/2
