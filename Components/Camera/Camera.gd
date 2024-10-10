extends Camera2D
signal update(zoom:Vector2,postion:Vector2)

func _ready():
	position = get_viewport_rect().size/2
	
var move_camera = false
var pre_mouse_pos = Vector2(0, 0)
var zoom_step = 1.02

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.is_pressed():
				pre_mouse_pos = event.position
				move_camera = true
			else:
				move_camera = false
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_at_point(zoom_step)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_at_point(1 / zoom_step)
	elif event is InputEventMouseMotion and move_camera:
		position += (pre_mouse_pos - event.position) / zoom
		#call singal
		update.emit(zoom,position)
		
		pre_mouse_pos = event.position
		

func zoom_at_point(zoom_change):
	if (zoom * zoom_change).x < 0.37688:
		return
	var point = get_local_mouse_position();
	zoom = zoom * zoom_change;
	var diff = point - get_local_mouse_position()
	offset += diff;
	
	#call singal
	update.emit(zoom,position)
