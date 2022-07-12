extends KinematicBody2D

export var speed = 80
var can_move = true
var in_menu = false

onready var arm_anim = get_node("../Arm/anim")

func _process(delta):
	if Input.is_action_pressed("left") and can_move:
		move_and_slide(Vector2(-speed, 0))
	elif Input.is_action_pressed("right") and can_move:
		move_and_slide(Vector2(speed, 0))
	move_and_slide(Vector2(0, 20))


func _input(event):
	if event.is_action_pressed("collect"):
		if not in_menu and can_move:
			for b in $Area2D.get_overlapping_areas():
				b = b.get_node("../")
				if b.is_in_group("BunkerEntrance"):
					can_move = false
					Global.transition()
					yield(get_tree().create_timer(1.0), "timeout")
					get_tree().change_scene("res://SavedGamestate.tscn")
				
				elif b.is_in_group("Table"):
					can_move = false
					in_menu = true
					Global.blueprint_up = true
					Global.selected = 0
					arm_anim.play("arm_up")
		elif in_menu:
			can_move = true
			in_menu = false
			Global.blueprint_up = false
			Global.selected = -1
			arm_anim.play("arm_down")
			
				
		
	
	
