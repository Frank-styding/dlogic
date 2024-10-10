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


@onready var conection = preload("res://Components/Gate/Connection.tscn") #panel


@export var connection_width: int = 49:
	set(value):
		connection_width = value
		update_container_separation()
		
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

var cell_size = 100

func _ready():
	cell_size = GridData.cell_size
	update_container_separation()
	
	from_data({
		"dimention":Vector2i(3,3),
		"connections":[
			{
				"name":"B",
				"position":1
			},
			{
				"name":"C",
				"position":1
			}
		]
	})
	
	
func from_data(data:Dictionary):
	set_dimention(data["dimention"])
	create_conections(data["connections"])
	


var dimention = Vector2i(1,1)
func set_dimention(n_dimention:Vector2i):
	set_size(n_dimention * GridData.cell_size)
	dimention = n_dimention
	
func get_container(_position:int):
	if _position == 0:
		return bottom_container
	if _position == 1:
		return right_container
	if _position == 2:
		return top_container
	if _position == 3:
		return left_container
		
func connection_click(data:Dictionary):
	print(data["name"])

func create_conections(data:Array):
	for connection_data in data:
		var _position = connection_data["position"] as int
		var container = get_container(_position)
		var n_conection = conection.instantiate() as GateConnection
		n_conection.mouse_click.connect(connection_click)
		n_conection.set_data(connection_data)
		container.add_child(n_conection)


