extends CanvasModulate

export var colors: Array
export var gradient: Gradient

#var color_len = 0.0
#var trans_len = 0.0
#var rgb_curr: Array = []
#var timer = 0.0

func _ready():
	pass
#	rgb_curr = [colors[0].r, colors[0].g, colors[0].b]
#	color = Color(colors[0].r, colors[0].g, colors[0].b)
#	color_len = len(colors)-1
#	trans_len = Global.CYCLE_LEN/color_len
	
func _process(delta):
	color = gradient.interpolate((Global.time + Global.timer)/Global.CYCLE_LEN)
#	var phase = floor((Global.time/Global.CYCLE_LEN)*(Global.CYCLE_LEN/trans_len))
#	timer += delta
#
#	if Global.time >= Global.CYCLE_LEN:
#		Global.time = 0
#	var rgb_delta = [0, 0, 0]
#	rgb_delta = [(colors[phase+1].r-colors[phase].r)/trans_len, (colors[phase+1].g-colors[phase].g)/trans_len, (colors[phase+1].b-colors[phase].b)/trans_len]
#	rgb_curr[0] += rgb_delta[0]*delta
#	rgb_curr[1] += rgb_delta[1]*delta
#	rgb_curr[2] += rgb_delta[2]*delta
#	color = Color(rgb_curr[0], rgb_curr[1], rgb_curr[2])
	
