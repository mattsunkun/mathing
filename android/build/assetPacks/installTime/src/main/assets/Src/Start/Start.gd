extends Node2D

@onready var l_time_left = $lTimeLeft
@onready var t_count_down = $tCountDown
@onready var asp_count_down = $aspCountDown
@onready var asp_start = $aspStart

var fltERROR:float = 0.1
# Called when the node enters the scene tree for the first time.
func _ready():
	t_count_down.wait_time = 4.0
	t_count_down.start()
	asp_count_down.volume_db = Data.persist.flt_volume_se - 8.0
	asp_count_down.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
var is_never_started_sound = true
func _process(delta):
	l_time_left.text = str(t_count_down.time_left).pad_decimals(0)
	
	if(t_count_down.time_left < fltERROR + 1.0):
		l_time_left.text = "すたーと"
		asp_count_down.stop()
		if(is_never_started_sound):
			asp_start.volume_db = Data.persist.flt_volume_se - 10.0
			asp_start.play()
			is_never_started_sound = false
	#if(!asp_start.playing):
		#asp_start.play()
	if(t_count_down.time_left < fltERROR):
		get_tree().change_scene_to_file("res://Src/Stage/Stage.tscn")
