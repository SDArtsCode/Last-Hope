extends RichTextLabel


func _ready():
	pass

func _input(event):
	if event.is_action_pressed("drop_mode"):
		if is_visible_in_tree():
			hide()
		else:
			show()
