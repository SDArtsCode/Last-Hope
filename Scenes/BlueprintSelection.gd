extends Node2D

var up: bool = false
var num_blueprints = 0
var blueprints: Array
var xtarg = 0
onready var slider = $slide

const GAP = 128

onready var blueprint_scene = preload("res://Scenes/Blueprint.tscn")

func _ready():
	for key in Global.blueprints.keys():
		if Global.blueprints[key]["has_blueprint"]:
			blueprints.append(key)
	var count = 0
	for blueprint in blueprints:
		var blueprint_instance = blueprint_scene.instance()
		blueprint_instance.position = Vector2(GAP*count, 40)
		blueprint_instance.blueprint = blueprint
		blueprint_instance.index = count
		slider.add_child(blueprint_instance)
		count += 1

func _process(delta):
	slider.position.x += (xtarg-slider.position.x)*delta*5


func _input(event):
	if event.is_action_pressed("left") and Global.selected != 0 and Global.blueprint_up:
		Global.selected -= 1
		xtarg += GAP
	if event.is_action_pressed("right") and Global.selected != len(blueprints)-1 and Global.blueprint_up:
		Global.selected += 1
		xtarg -= GAP
		
