extends Node3D

@export_category("Turtle Resource")
@export var nomral_turtle: MeshInstance3D

var id: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	var turtle = self.nomral_turtle.duplicate()
	turtle.position = Vector3(0, 0, 0)
	turtle.name = "Turtle" + str(self.id)
	self.id += 1
	turtle.visible = true
	add_child(turtle)


#func _on_node_turtle_update(turtle):
#	var child = self.find_child("turtle_%s" % turtle.name)
#	if child == null:
#		var coordinates = turtle.coordinates
#		var new_turtle = self.nomral_turtle.duplicate()
#		new_turtle.position = Vector3(coordinates.x, coordinates.y, coordinates.z)
#		new_turtle.name = "turtle_%s" % turtle.name
#		new_turtle.visible = true
#		add_child(new_turtle)


func _update_turtle(turtle: Dictionary):
	print("Received turtle data:", turtle)
	var coordinates = turtle.coordinates
	var new_position = Vector3(coordinates.x, coordinates.y, coordinates.z)
	var child = self.find_child("turtle_%s" % turtle.name, true, false)
	if child == null:
		var new_turtle = self.nomral_turtle.duplicate()
		new_turtle.position = new_position
		new_turtle.name = "turtle_%s" % turtle.name
		new_turtle.visible = true
		self.add_child(new_turtle)
	else:
		child.position = new_position
