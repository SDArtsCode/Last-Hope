extends AnimationPlayer


func _ready():
	get_node("../").show()
	Global.transition_nodes.append(self)
	
