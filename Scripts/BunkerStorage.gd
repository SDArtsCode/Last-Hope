extends Node2D

onready var bunker_icon = preload("res://Scenes/BunkerIcon.tscn")
const MAX_FROM_BASE = 1000

func _ready():
	var num_item = 0
	for item in Global.items.keys():
		if item != "blueprint" and Global.items[item]["bunker"] != 0:
			num_item += 1
	print(num_item)
	var item_num = 0
	var index = 0 
	for item in Global.items.keys():
		if item != "blueprint" and Global.items[item]["bunker"] != 0:
			item_num += 1
			var bunker_icon_inst = bunker_icon.instance()
			bunker_icon_inst.item = item
			bunker_icon_inst.position.x = (MAX_FROM_BASE/(num_item+1))*item_num-MAX_FROM_BASE/2 
			add_child(bunker_icon_inst)

