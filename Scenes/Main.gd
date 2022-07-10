extends Node2D

onready var inventory = preload("res://Scenes/Inventory.tscn")


func _on_Button_pressed() -> void:
	var inventory_instance = inventory.instance()
	inventory_instance.position.x = self.position.x - 125 #NEED TO GET PLAYER POSITION NOT SELF BUT TOO LAZY RIGHT NOW...
	inventory_instance.position.y = self.position.y - 300 #NEED TO GET PLAYER POSITION NOT SELF BUT TOO LAZY RIGHT NOW...
	add_child(inventory_instance)

func _physics_process(delta: float) -> void:
	pass

