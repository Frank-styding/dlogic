@tool
class_name Gate

extends Panel

@onready var label_name = $Label/Name

@onready var margin_top = $TopMargin as MarginContainer
@onready var margin_bottom = $BottomMargin as MarginContainer
@onready var left_margin = $LeftMargin as MarginContainer
@onready var margin_right = $RightMargin as MarginContainer

@onready var top_container = $TopMargin/TopContainer as Container
@onready var bottom_container = $BottomMargin/BottomContainer as Container
@onready var left_container = $LeftMargin/LeftContainer as Container
@onready var right_container = $RightMargin/RightContainer as Container


@onready var connectionInst = preload("res://Components/Gate/Connection.tscn") #panel
@onready var spaceInst = preload("res://Components/Gate/Space.tscn") #panel


@export var connection_width: int = 49:
	set(value):
		connection_width = value
		update_container_separation()
		

## Variables
var cell_size = 100
var dimention = Vector2i(1,1)

func _ready():
	cell_size = GridData.cell_size
	update_container_separation()
	
	from_data({
		"dimention":Vector2i(3,3),
		"connections":{
			0:[{"name":"A"},{},{"name":"B"}],
			1:[],
			2:[],
			3:[]
		}
	})
	
func connection_click(data:Dictionary):
	print(data["name"])

func update_container_separation():
	if not (left_container and right_container and top_container and bottom_container):
		return
		
	if not (margin_top and margin_right and margin_bottom and margin_top):
		return
		
	var separation = cell_size - connection_width
	var half_separation = int(float(separation) / 2)
		
	left_container.set("theme_override_constants/separation",separation)
	right_container.set("theme_override_constants/separation",separation)
	top_container.set("theme_override_constants/separation",separation)
	bottom_container.set("theme_override_constants/separation",separation)
	
	left_margin.set("theme_override_constants/margin_top",half_separation)
	margin_right.set("theme_override_constants/margin_top",half_separation)
	margin_top.set("theme_override_constants/margin_left",half_separation)
	margin_bottom.set("theme_override_constants/margin_left",half_separation)

func from_data(data:Dictionary):
	set_dimention(data["dimention"])
	create_connections(data["connections"])

func set_dimention(n_dimention:Vector2i):
	set_size(n_dimention * GridData.cell_size)
	dimention = n_dimention
	# Delete childs
	var connections = top_container.get_children() + bottom_container.get_children() + left_container.get_children() + right_container.get_children()
	for child in connections:
		child.queue_free()

func get_container(_position:int):
	if _position == 0:
		return bottom_container
	if _position == 1:
		return right_container
	if _position == 2:
		return top_container
	if _position == 3:
		return left_container

func create_connections(data:Dictionary):
	for i in range(4):
		for connection_data in data[i]:
			var container = get_container(i)
			if connection_data.has("name"):
				var n_connection = connectionInst.instantiate() as GateConnection
				n_connection.mouse_click.connect(connection_click)
				n_connection.set_data(i,connection_data)
				container.add_child(n_connection)
			else:
				var n_space = spaceInst.instantiate() as ConnectionSpace
				n_space.set_direction(i)
				container.add_child(n_space)
