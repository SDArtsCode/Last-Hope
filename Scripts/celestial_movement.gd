extends AnimatedSprite

const PLAYER_OFFSET = 300
const YTARG = -1000
const YOFFSET = 1100


func _ready():
	position.x = PLAYER_OFFSET

func _process(delta):
	var day_prog = ((Global.time + Global.timer)/Global.CYCLE_LEN) * 3
	if day_prog >= 1.0 and day_prog < 2.0:
		day_prog -= 1.0
		day_prog = 1.0-day_prog
		frame = 1
	
	if day_prog >= 2.0:
		day_prog -= 2.0
		frame = 0
		
	
	position.y = day_prog * YTARG + YOFFSET
	
