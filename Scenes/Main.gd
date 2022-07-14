extends Node2D

# run resets wen the player exits the bunker here
func _ready():
	Global.time = 0
	Global.root = self
	Global.transition()


func save_scene():
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene())
	ResourceSaver.save("res://SavedGamestate.tscn", packed_scene)
