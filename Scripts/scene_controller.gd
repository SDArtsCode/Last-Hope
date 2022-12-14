extends Node

var scenes_in_game : Dictionary = {
	1 : preload("res://Scenes/Levels/1.tscn"),
	2 : preload("res://Scenes/Levels/2.tscn"),
	3 : preload("res://Scenes/Levels/3.tscn"),
	4 : preload("res://Scenes/Levels/4.tscn"),
	5 : preload("res://Scenes/Levels/5.tscn"),
	6 : preload("res://Scenes/Levels/6.tscn"),
	#7 : preload("res://Scenes/Levels/7.tscn"),
	8 : preload("res://Scenes/Levels/8.tscn")
	
}

var cur_scene_name = 3
var cur_scene = null

var scene_transition_time : float = 3.0
enum {
	IN_SCENE,
	TRANS_OUT,
	TRANS_MID,
	TRANS_IN
}
var state = IN_SCENE

func _ready():
	#$CanvasLayer/TransitionShader.show()
	switch_scene(3)
		
func switch_scene(new_scene_name):
	if scenes_in_game.keys().has(new_scene_name):
		if scenes_in_game[new_scene_name] != null:
			state = TRANS_IN
#			$CanvasLayer/TransitionShader.material.set_shader_param('dir', 1)
#			$Tween.interpolate_property($CanvasLayer/TransitionShader.material, 
#			"shader_param/position",
#			2.5, 0.0, scene_transition_time / 2.0, Tween.TRANS_LINEAR)
#			$Tween.start()
			cur_scene_name = new_scene_name
			#$Timer.start(scene_transition_time / 2.0)
			change_state()
		else:
			print("Cur scene does not have a complementary scene")
	else:
		print("Cur scene name does not exist")


func _on_Timer_timeout():
	if state == TRANS_IN:
		state = TRANS_MID
		#$Timer.start(0.2)
		$Timer.start(0.1)
	elif state == TRANS_MID:
#		$CanvasLayer/TransitionShader.material.set_shader_param('dir', -1)
		state = TRANS_OUT
#		$Tween.interpolate_property($CanvasLayer/TransitionShader.material, 
#		"shader_param/position",
#		0.0, 2.5, scene_transition_time / 2.0, Tween.TRANS_LINEAR)
#		$Tween.start()
		if cur_scene != null:
			cur_scene.queue_free()
		cur_scene = scenes_in_game[cur_scene_name].instance()
		add_child(cur_scene)
		$Timer.start(0.1)
		# $Timer.start(scene_transition_time / 2.0)
	elif state == TRANS_OUT:
		state = IN_SCENE
	elif state == IN_SCENE:
		pass

func change_state():
	if state == TRANS_IN:
		state = TRANS_MID
		#$Timer.start(0.2)
		change_state()
	elif state == TRANS_MID:
#		$CanvasLayer/TransitionShader.material.set_shader_param('dir', -1)
		state = TRANS_OUT
#		$Tween.interpolate_property($CanvasLayer/TransitionShader.material, 
#		"shader_param/position",
#		0.0, 2.5, scene_transition_time / 2.0, Tween.TRANS_LINEAR)
#		$Tween.start()
		if cur_scene != null:
			cur_scene.queue_free()
		cur_scene = scenes_in_game[cur_scene_name].instance()
		add_child(cur_scene)
		change_state()
		# $Timer.start(scene_transition_time / 2.0)
	elif state == TRANS_OUT:
		state = IN_SCENE
	elif state == IN_SCENE:
		pass
		
func set_transition_pos(pos : float):
	$CanvasLayer/TransitionShader.material.set_shader_param('position', pos)
	
