extends AnimatedSprite


var item_name: String
var item_count: int
var item_id: int
var select_id: int
var selected = false

func _ready():
	$itemname.text = item_name
	$itemcount.text = str(item_count)
	frame = item_id

func _process(delta):
	if selected:
		$selected.show()
	else:
		$selected.hide()
