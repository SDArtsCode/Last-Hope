extends AnimatedSprite

export var item: String

func _ready():
	frame = Global.items.keys().find(item)

func _process(delta):
	$Label.text = str(Global.items[item]["name"]) + ":\n" + str(Global.items[item]["bunker"])
