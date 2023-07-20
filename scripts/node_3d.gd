extends Node3D

var stream = StreamPeerTCP.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	stream.connect_to_host("127.0.0.1", 8081)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stream.put_string("Hello world")
#	var out = stream.get_string()
#	if !out.is_empty():
#		print(out)
