extends Node2D


func _physics_process(delta: float) -> void:
	
	if Global.item_collected == true:
		$Panel/Label.text = Global.item_name
		$Label.text = str(Global.item_weight) + " kg"
		
		$Panel2/Label.text = Global.item_name
		$Label2.text = str(Global.item_weight) + " kg"
	
	
