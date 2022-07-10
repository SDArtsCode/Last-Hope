extends RichTextLabel


func _ready():
	Global.info_log = self


func Update(info: String, color: String):
	bbcode_text = "[color=" + color + "]" + info + "[/color]"
	$flash.stop()
	$flash.play("falsh")
	if color != "yellow":
		$notif.play()
	
