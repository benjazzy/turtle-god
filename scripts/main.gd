extends Node

@export var connect_window: Window
@export var connect_address: LineEdit

@export var connected_icon: Sprite2D
@export var connecting_icon: Sprite2D
@export var disconnected_icon: Sprite2D

signal turtle_update(turtle: Dictionary)

var connection: StreamPeerTCP = StreamPeerTCP.new()

var buffer: Array = []
var mark: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(4):
		mark.push_back(0xA)
	
	self.connect_window.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.connection.poll()
	var status = self.connection.get_status()
	
	if status == StreamPeerTCP.STATUS_CONNECTED:
		self.connected_icon.visible = true
		self.connecting_icon.visible = false		
		self.disconnected_icon.visible = false
		
		if self.connect_window.visible:
			self.connect_window.hide()
		
		self.recv_messages()
		
	elif status == StreamPeerTCP.STATUS_CONNECTING:
		self.connected_icon.visible = false
		self.connecting_icon.visible = true
		self.disconnected_icon.visible = false
		
		if !self.connect_window.visible:
			self.connect_window.show()
			
	else:
		self.connected_icon.visible = false
		self.connecting_icon.visible = false				
		self.disconnected_icon.visible = true
		
		if !self.connect_window.visible:
			self.connect_window.show()

func _connect():
	var split = self.connect_address.text.split(":")
	if split.size() != 2:
		printerr("Invalid address")
		return
	
	print(split)
	self.connection.disconnect_from_host()
	
	var error = self.connection.connect_to_host(split[0], int(split[1]))
	if error:
		printerr("Problem connecting")
		return
	
	self.connection.put_string("test")
	
func recv_messages():
	var available = self.connection.get_available_bytes()
	if available == 0:
		return
	print("Available: %s" % available)
	var partial = self.connection.get_partial_data(available)
	if partial.is_empty():
		return
	
	for i in partial.size():
		var b = partial[i]
		if b is PackedByteArray:
			for byte in b:
				self.buffer.push_back(byte)
		
	if self.buffer.size() < 4:
		return
	
	var pos = -1
	
	for i in self.buffer.size() - 3:
		if self.check_next_bytes(i):
			pos = i
			break
	
	if pos == -1:
		return
	
	var message_buffer = []
	for i in pos + 4:
		var b = self.buffer.pop_front()
		message_buffer.push_back(b)
	for i in 4:
		message_buffer.pop_back()
	
	var message_string = PackedByteArray(message_buffer).get_string_from_utf8()
	var json = JSON.new()
	var error = json.parse(message_string)
	if error == OK:
		var message = json.data
		print(message)
		self.handle_message(message)
	else:
		printerr("Problem parsing json")
	
	print("Bytes left: %s" % self.buffer.size())

func check_next_bytes(buff_i: int):
	for mark_i in self.mark.size():	
		if self.mark[mark_i] != self.buffer[buff_i]:
			return false
		buff_i += 1
	
	return true

func handle_message(message: Dictionary):
	match message.type:
		"turtles":
			for turtle in message.turtles:
				print("Emitting turtle_update signal with:", turtle)
				self.turtle_update.emit(turtle)

func _on_button_pressed():
	var request = {
		"type": "get_turtles",
	}
	
	var message = JSON.stringify(request)
	var bytes = message.to_utf8_buffer()
	for b in self.mark:
		bytes.append(b)
	var error = self.connection.put_data(bytes)
	if error != OK:
		printerr("Problem sending request: %e" % error)
