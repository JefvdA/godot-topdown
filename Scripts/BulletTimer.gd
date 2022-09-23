extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	var _x = connect("timeout", self, "remove")

func remove():
	get_parent().queue_free()
