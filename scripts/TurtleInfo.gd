extends Window


# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = self.get_parent()
	self.name = parent.name
	self.hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
