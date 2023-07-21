extends Node3D

@export var connection: Node

@export_category("Turtle Resource")
@export var nomral_turtle: Node3D

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
	
func _on_turtle_move_button(name: String, direction: String):
	print("Turtle %s moving %s" % [name, direction])
	var command = {
		"type": "move",
		"name": name,
		"direction": direction,
	}
	self.connection.send_command(command)

#func _on_node_turtle_update(turtle):
#	var child = self.find_child("turtle_%s" % turtle.name)
#	if child == null:
#		var coordinates = turtle.coordinates
#		var new_turtle = self.nomral_turtle.duplicate()
#		new_turtle.position = Vector3(coordinates.x, coordinates.y, coordinates.z)
#		new_turtle.name = "turtle_%s" % turtle.name
#		new_turtle.visible = true
#		add_child(new_turtle)

func heading_to_rotation(char: String):
	match char:
		"n":
			return deg_to_rad(90)
		"s": 
			return deg_to_rad(270)
		"e": 
			return deg_to_rad(0)
		"w":
			return deg_to_rad(180)
		

func _update_turtle(turtle: Dictionary):
	print("Received turtle data:", turtle)
	var coordinates = turtle.coordinates
	var new_position = Vector3(coordinates.x, coordinates.y, coordinates.z)
	var rotation = heading_to_rotation(turtle.heading)
	if rotation == null:
		return
		
	var child = self.find_child(turtle.name, true, false)
	if child == null:
		#var new_turtle = self.nomral_turtle.duplicate(DUPLICATE_GROUPS | DUPLICATE_SCRIPTS | DUPLICATE_SIGNALS)
		var new_turtle = preload("res://turtle.tscn").instantiate()
		new_turtle.setup_window(turtle.name)
		new_turtle.name = turtle.name
		new_turtle.global_rotation = Vector3(0, rotation, 0)
		new_turtle.move(new_position)
		
		new_turtle.visible = true
		new_turtle.move_signal.connect(self._on_turtle_move_button)
		self.add_child(new_turtle)
	else:
		child.move(new_position)
		child.global_rotation = Vector3(0, rotation, 0)
