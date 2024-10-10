class_name Grid
extends Node2D

var grid_size = Vector2(0,0)
var grid_dim = Vector2i(0,0)
var grid_view_area = Vector2(0,0)
var chuncks = 3
var center = Vector2(0,0)
var box:StyleBox = null
var updated = true
var screen_size = Vector2(0,0)

@onready var Tile = preload("res://Components/Grid/Tile.tscn")

func _ready():
	screen_size = get_viewport_rect().size
	position = screen_size/2
	center = screen_size/2
	calc_grid_size()
	create_tiles()
	

func create_tiles():
	var grid_center = Vector2(grid_size) / 2
	var cell_size = Vector2(1,1) * GridData.cell_size
	for x in grid_dim.x:
		for y in grid_dim.y:
			var pos = -grid_center + Vector2(x,y) * GridData.cell_size
			var tile = Tile.instantiate() as Panel
			tile.position = pos
			add_child(tile)
				
	
	#box = StyleBoxFlat.new()
	#box.set_corner_radius_all(5)
	#box.bg_color = GridData.background_color

func fix_to_grid_size(size):
	return Vector2i(floor(size / GridData.cell_size))
	
func convert_to_ood(v:Vector2i):
	var x = v.x + (1 - v.x % 2) 
	var y = v.y + (1 - v.y % 2) 
	return Vector2i(x,y)

func calc_grid_size():
	var fixed_screen_size = fix_to_grid_size(screen_size)
	grid_dim = fixed_screen_size * floor(2 * chuncks - 1);
	grid_dim = convert_to_ood(grid_dim)
	grid_view_area =  fixed_screen_size * GridData.cell_size
	grid_size = grid_dim * GridData.cell_size

func update_grid_pos(pos):
	var diff = pos - position
	if diff.x  > grid_view_area.x/2:
		position.x += grid_view_area.x
	if diff.x  < -grid_view_area.x/2:
		position.x += -grid_view_area.x 
	if diff.y  > grid_view_area.y/2:
		position.y += grid_view_area.y
	if diff.y  < -grid_view_area.y/2:
		position.y += -grid_view_area.y
		
#func _draw():
	#print("drwa")
	#draw_rect(Rect2(-grid_size/2,grid_size),GridData.line_color)
	#var pos = Vector2(grid_size) / 2
	#var border_pos = Vector2(1,1) * GridData.line_width
	#var cell_size = Vector2(1,1) * GridData.cell_size
	#for x in grid_dim.x:
		#for y in grid_dim.y:
			#var rect = Rect2(
					#-pos + border_pos +
					#Vector2(x,y) * GridData.cell_size,
					#cell_size - border_pos * 2
			#)
			#draw_style_box(box,rect)

func _on_camera_update(_zoom, pos):
	update_grid_pos(pos)

func get_mouse_grid_pos():
	var mouse_pos = get_global_mouse_position() - center
	var cell_pos = floor(
		(
			mouse_pos + Vector2(1,1) * GridData.cell_size/2
		)/ (GridData.cell_size)
	)
	return cell_pos
