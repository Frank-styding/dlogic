@tool
class_name Grid
extends Node2D

var grid_size = Vector2(0,0)
var grid_dim = Vector2i(0,0)
var grid_view_area = Vector2(0,0)

var center = Vector2(0,0)
var box:StyleBox = null
var updated = true
var screen_size = Vector2(0,0)

var multi_mesh:MultiMesh
var plane_mesh: PlaneMesh

@onready var multi_mesh_instance = $MultiMeshInstance2D

@export var texture:Texture:
	set(value):
		texture = value
		if not multi_mesh_instance:return
		multi_mesh_instance.texture = texture
		
@export var chuncks:float = 3:
	set(value):
		chuncks = value
		if not multi_mesh_instance and not plane_mesh:return
		_ready()
		


func _ready():
	screen_size = get_viewport_rect().size
	position = screen_size/2
	center = screen_size/2
	calc_grid_size()
	#generate_texture()
	
	plane_mesh =  PlaneMesh.new()
	plane_mesh.size = Vector2(1,1) * GridData.cell_size
	plane_mesh.orientation = PlaneMesh.FACE_Z
	
	multi_mesh = MultiMesh.new()
	multi_mesh.instance_count = grid_dim.x * grid_dim.y
	multi_mesh.mesh = plane_mesh
	multi_mesh_instance.texture = texture
	multi_mesh_instance.multimesh = multi_mesh
	multi_mesh_instance.texture_filter = TextureFilter.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	create_tiles()

func create_tiles():
	var grid_center = Vector2(grid_size) / 2
	var cell_size = Vector2(1,1) * GridData.cell_size
	for x in grid_dim.x:
		for y in grid_dim.y:
			var pos = -grid_center + Vector2(x + 0.5,y + 0.5) * GridData.cell_size
			var i = x + grid_dim.x * y
			var t = Transform2D(0.0,pos)
			multi_mesh.set_instance_transform_2d(i,t)
			
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
