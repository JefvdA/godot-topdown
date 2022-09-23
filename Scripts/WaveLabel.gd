extends Label


func _process(_delta):
	text = "WAVE: " + str(Global.wave + 1)
