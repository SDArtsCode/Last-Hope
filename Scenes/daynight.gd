extends CanvasModulate

export var time = 0.0
export var cycle_len = 1200.0
export var colors: Array

var color_len = 0.0
var trans_len = 0.0
var rgb_curr: Array = []
var timer = 0.0

func _ready():
	rgb_curr = [colors[0].r, colors[0].g, colors[0].b]
	color = Color(colors[0].r, colors[0].g, colors[0].b)
	color_len = len(colors)-1
	trans_len = cycle_len/color_len
	
func _process(delta):
	var phase = floor((time/cycle_len)*(cycle_len/trans_len))
	timer += delta
	if timer >= 1.0:
		time += 1
		timer -= 1.0
		if time >= cycle_len:
			time = 0
		var rgb_delta = [(colors[phase+1].r-colors[phase].r)/trans_len, (colors[phase+1].g-colors[phase].g)/trans_len, (colors[phase+1].b-colors[phase].b)/trans_len]
		rgb_curr[0] += rgb_delta[0]
		rgb_curr[1] += rgb_delta[1]
		rgb_curr[2] += rgb_delta[2]
		color = Color(rgb_curr[0], rgb_curr[1], rgb_curr[2])
	
