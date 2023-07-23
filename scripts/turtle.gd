extends Node3D

signal move_signal(name: String, direction: String)

@export_category("Info")
@export var info_window: Window
@export var position_x: Label
@export var position_y: Label
@export var position_z: Label

@export_category("Status")
@export var ConnectedStatusPanel: PanelContainer
@export var DisconnectedStatusPanel: PanelContainer

var hovering = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	self.info_window.title = self.name
#	self.info_window.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if self.hovering and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Showing:", self.name)
			self.info_window.show()

#func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
#	print(event)
#	if event is InputEventMouse:
#		if event.pressed:
#			print("Pressed")
#		if event.button_index == MOUSE_BUTTON_LEFT:
#			print("Click")

func set_connected():
	print("Connected")
	self.ConnectedStatusPanel.show()
	self.DisconnectedStatusPanel.hide()

func set_disconnected():
	print("Disconnected")
	self.ConnectedStatusPanel.hide()
	self.DisconnectedStatusPanel.show()

func _on_area_3d_mouse_entered():
	self.hovering = true


func _on_area_3d_mouse_exited():
	self.hovering = false


func _on_turtle_info_close_requested():
	self.info_window.hide()

func setup_window(name: String):
	self.info_window.title = name
	self.info_window.hide()
	

func move(position: Vector3):
	self.position = position
	self.position_x.text = str(position.x)
	self.position_y.text = str(position.y)
	self.position_z.text = str(position.z)


func _on_up_pressed():
	self.move_signal.emit(self.name, "u")

func _on_down_pressed():
	self.move_signal.emit(self.name, "d")

func _on_left_pressed():
	self.move_signal.emit(self.name, "l")

func _on_right_pressed():
	self.move_signal.emit(self.name, "r")
	
func _on_forward_pressed():
	self.move_signal.emit(self.name, "f")

func _on_back_pressed():
	self.move_signal.emit(self.name, "b")

