extends ProgressBar

onready var item_icon = preload("res://Scenes/inventory_item.tscn")
onready var item = preload("res://Scenes/Item.tscn")

const MAX_FROM_BASE = 900

var drop_mode: bool = false
var highlight_index: int = 0
var num_item = 0

func _ready():
	Global.inventory_controller = self
	max_value = Global.player_parts["storage"]

func _process(delta):
	if drop_mode:
		Global.send("[center]- DROPPING -[/center]", "yellow")
		

func _input(event):
	if event.is_action_pressed("drop_mode"):
		if not drop_mode:
			Global.player.can_move = false
			drop_mode = true
			highlight_index = 0
			for child in $Base.get_children():
				if child.select_id == highlight_index:
					child.selected = true
				else:
					child.selected = false
		else:
			Global.send("", "yellow")
			Global.player.can_move = true
			drop_mode = false
			for child in $Base.get_children():
				child.selected = false
		
	if drop_mode and event.is_action_pressed("left") and highlight_index > 0:
		highlight_index -= 1
		update_index()
	
	if drop_mode and event.is_action_pressed("right") and highlight_index < num_item-1:
		highlight_index += 1
		update_index()
	
	if drop_mode and event.is_action_pressed("drop"):
		for child in $Base.get_children():
			if child.selected and child.item_count != 0:
				Global.change_item_count(Global.get_base_name(child.item_name), -1)
				var item_inst = item.instance()
				item_inst.item_name = Global.get_base_name(child.item_name)
				item_inst.position = Global.player.position + Vector2(360, -90)
				item_inst.apply_central_impulse(Vector2(200,30)*Global.player.get_local_mouse_position().normalized())
				Global.root.add_child(item_inst)
				if highlight_index == num_item:
					highlight_index -= 1
				update_index()

func update_inventory():
	# murder all children
	for child in $Base.get_children():
		child.queue_free()
	
	# count how many items have stuff
	num_item = 0
	for item in Global.items.values():
		if item["stored"] != 0:
			num_item += 1
	
	# reinstanciate all children and pretend like nothing happened
	var item_num = 0
	var index = 0 
	value = 0.0
	for item in Global.items.values():
		if item["stored"] != 0:
			item_num += 1
			value += item["volume"]*item["stored"]
			var item_icon_inst = item_icon.instance()
			item_icon_inst.item_name = item["name"]
			item_icon_inst.item_count = item["stored"]
			item_icon_inst.item_id = index
			item_icon_inst.select_id = item_num - 1
			item_icon_inst.position.x = (MAX_FROM_BASE/(num_item+1))*item_num-MAX_FROM_BASE/2 # change - to + to left align
			$Base.add_child(item_icon_inst)
			
		index += 1
	Global.curr_inventory = value
	$indicator.text = str(Global.curr_inventory) + "/" + str(Global.player_parts["storage"]) + " m³"
	
func update_index():
	for child in $Base.get_children():
		if child.select_id == highlight_index:
			child.selected = true
		else:
			child.selected = false

