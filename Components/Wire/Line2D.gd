@tool
extends AntialiasedLine2D


func _ready():
	for i in points.size() - 1:
		var new_shape = CollisionShape2D.new()
		$Area2D.add_child(new_shape)
		var rect = RectangleShape2D.new()
		new_shape.position = (points[i] + points[i + 1]) / 2
		new_shape.rotation = points[i].direction_to(points[i + 1]).angle()
		var length = points[i].distance_to(points[i + 1])
		rect.extents = Vector2(length / 2 + width / 2, width/2)
		new_shape.shape = rect
		
func update_shape(time):
	var child_count = len($Area2D.get_children())
	if child_count > points.size():
		for i in range(points.size()-1, child_count):
			$Area2D.get_child(i).queue_free()
	else:
		for i in points.size() - 1:
			var new_shape = CollisionShape2D.new()
			$Area2D.add_child(new_shape)
			
	for i in points.size() - 1:
		var shape = $Area2D.get_child(i)
		var rect = RectangleShape2D.new()
		shape.position = (points[i] + points[i + 1]) / 2 
		shape.rotation = points[i].direction_to(points[i + 1]).angle()
		var length = points[i].distance_to(points[i + 1])
		if i == 0 or i == points.size() - 2:
			rect.extents = Vector2(length / 2  , width/2)
		else:
			rect.extents = Vector2(length/2 + width /2, width/2)
			shape.shape = rect
