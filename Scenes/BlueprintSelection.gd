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
	xtarg = -GAP*Global.selected
	if Global.selected == -2:
		modulate = Color(0.5, 0.5, 0.5)
	if Global.entered:
		yield(get_tree().create_timer(0.001), "timeout")
		for child in $slide.get_children():
			child.update_ui()



func _input(event):
	if Global.selected == -2 and Global.blueprint_up and (event.is_action_pressed("left") or event.is_action_pressed("right")):
		Global.selected = 0
		modulate = Color(1, 1, 1)
		Global.outfitting_menu.selected = -10
	
	
	if event.is_action_pressed("left") and Global.selected != 0 and Global.blueprint_up:
		Global.selected -= 1
#		xtarg += GAP
	if event.is_action_pressed("right") and Global.selected != len(blueprints)-1 and Global.blueprint_up:
		Global.selected += 1
#		xtarg -= GAP
	if event.is_action_pressed("select") and Global.selected >= 0:
		if Global.can_enter:
			Global.entered = true
		else:
			$flash.play("flash")
		
