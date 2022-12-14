extends Node


onready var ambience: Dictionary = {
	"residential": $ambience/residental,
	"construction": $ambience/construction,
	"sewers": $ambience/sewers,
	"market": $ambience/market, 
	"generator": $ambience/generator,
}

const maxes: Dictionary = {
	"residential": 6.0,
	"construction": 0.0,
	"sewers": 6.0,
	"market": 6.0, 
	"generator": 6.0
}

onready var motifs: Dictionary = {
	"day_start": $motifs/day_start,
	"new_area": $motifs/new_area,
	"friend": $motifs/friend,
}

const TRANSITION_SPEED_AMB = 0.1
const TRANSITION_SPEED_MOF = 0.5

var playing_ambience := ""
var playing_motif := ""
var active := false
var active1 := false

func play_ambiance(key: String):
	active = true
	playing_ambience = key
	
func play_motif(key: String):
	motifs[key].play()
	playing_motif = key
		

func _ready():
	playing_ambience = "residential"
	active = true

func _input(event):
	if event.is_action_pressed("debug"):
		match playing_ambience:
			"residential": playing_ambience = "construction"
			"construction": playing_ambience = "sewers"
			"sewers": playing_ambience = "market"
			"market": playing_ambience = "generator"
			"generator": playing_ambience = "residential"
		print(playing_ambience)
		active = true


func _process(delta):
	# handles ambience transitions
	if active:
		active = false
		for track in ambience.keys():
#			print(track, track == playing_ambience and db2linear(ambience[track].volume_db) < 1)
			if track != playing_ambience and db2linear(ambience[track].volume_db) > 0:
				ambience[track].volume_db = linear2db(clamp(db2linear(ambience[track].volume_db - maxes[track]) - TRANSITION_SPEED_AMB*delta, 0.0, 1.0)) + maxes[track]
				active = true
			
			elif track == playing_ambience and db2linear(ambience[track].volume_db) < db2linear(maxes[track]):
				ambience[track].volume_db = linear2db(clamp(db2linear(ambience[track].volume_db - maxes[track]) + TRANSITION_SPEED_AMB*delta, 0.0, 1.0)) + maxes[track]
				print(ambience[track].volume_db)
				active = true
	
	# handles motif transitions
	if active1:
		active1 = false
		for track in motifs.keys():
			if track != playing_motif and db2linear(motifs[track].volume_db) > 0:
				motifs[track].volume_db = linear2db(clamp(db2linear(motifs[track].volume_db) - TRANSITION_SPEED_MOF*delta, 0.0, 1.0))
				active1 = true
			
			elif track == playing_motif and db2linear(motifs[track].volume_db) < 1:
				motifs[track].volume_db = linear2db(clamp(db2linear(motifs[track].volume_db) + TRANSITION_SPEED_MOF*delta, 0.0, 1.0))
				active1 = true
