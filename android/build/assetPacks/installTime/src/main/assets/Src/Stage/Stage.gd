extends Node2D

@onready var l_problem = $lProblem
@onready var b_ans_0 = $bAns0
@onready var b_ans_1 = $bAns1
@onready var l_score = $lScore

@onready var l_time_left = $lTimeLeft
@onready var t_limit = $tLimit
@onready var cr_background = $crBackground

@onready var asp_tick = $aspTick
@onready var asp_tick_fast = $aspTickFast
@onready var asp_right = $aspRight

var ansInd:int = -1
var instance_rule = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	if(Data.instant.int_score != 0):
		asp_right.volume_db = Data.persist.flt_volume_se - 10.0
		asp_right.play()
		
	# 割り算で使うから，+1しておk<-NO
	var MAXDIGIT:int = 6
	var opNum:int = -1
	# rule
	if(Data.instant.rule == Literal.eRule.beginner):
		instance_rule = Literal.beginner_rule
		opNum = 0#randi()%2
		MAXDIGIT = 3
	if(Data.instant.rule == Literal.eRule.regular):
		instance_rule = Literal.regular_rule
		opNum = 1#randi()%3
		MAXDIGIT = 4
	if(Data.instant.rule == Literal.eRule.grand):
		instance_rule = Literal.grand_rule
		opNum = randi()%2
		MAXDIGIT = 5
	if(Data.instant.rule == Literal.eRule.impossible):
		instance_rule = Literal.impossible_rule
		opNum = randi()%2
		MAXDIGIT = 6
	
	# color
	cr_background.color = Literal.color.get_color(
		Data.instant.int_score, 
		instance_rule.int_max_score, 
		instance_rule.int_color_steps, 
		)
		
	Data.instant.color_result = cr_background.color
		
	# 時間制限
	t_limit.wait_time = instance_rule.flt_time_limit
	t_limit.start()
	
	# 進捗状況
	l_score.text = "%s%s%s" % [
		str(Data.instant.int_score).format("%.3f"),
		"/",
		str(instance_rule.int_max_score)
		]
	
	
	
	var maxNum:int = 10**MAXDIGIT
	
	var a:int = randi()%maxNum + 1
	var b:int = randi()%maxNum + 1
	
	var op:String = ""
	var ans:int = 0
	if(opNum == 0):
		op = "+"
		ans = a+b
	if(opNum == 1):
		op = "-"
		ans = a-b
	if(opNum == 2):
		op = "*"
		ans = a*b
	if(opNum == 3):
		op = "/"
		ans = a/b
		
	l_problem.text = "%s%s%s"%[str(a), op, str(b)]
	var diff:int = 10**(randi()%MAXDIGIT)
	# プラスかマイナスか
	if(randi()%2==0):
		diff = -diff
	
	# 答え
	if(randi()%2==0 or Data.instant.is_cheet):
		b_ans_0.text = "%s"%str(ans)
		b_ans_1.text = "%s"%str(ans+diff)
		# b_ans_0.modulate = Color(255, 0, 0)
		ansInd = 0
	else:
		b_ans_0.text = "%s"%str(ans+diff)
		b_ans_1.text = "%s"%str(ans)
		# b_ans_1.modulate = Color(255, 0, 0)
		ansInd = 1
	
	## color 出力デバッグ
	#l_problem.text = "%s,%s,%s" % [
		#cr_background.color.r8, 
		#cr_background.color.g8, 
		#cr_background.color.b8
	#]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	l_time_left.text = str(t_limit.time_left).pad_decimals(2)
	if(t_limit.time_left > 5.0):
		if(!asp_tick.playing):
			asp_tick.volume_db = Data.persist.flt_volume_se
			asp_tick.play()
	else:
		if(asp_tick.playing):
			asp_tick.stop()
		if(!asp_tick_fast.playing):
			asp_tick_fast.volume_db = Data.persist.flt_volume_se
			asp_tick_fast.play()
		

enum eAnswer {
	a0 = 0, 
	a1 = 1, 
	tle = -1, 
}

func _on_b_ans_0_pressed():
	_check_ans(eAnswer.a0)


func _on_b_ans_1_pressed():
	_check_ans(eAnswer.a1)
	
func _check_ans(yourAns:eAnswer):
	Data.instant.str_problem = l_problem.text
	Data.instant.str_choice_0 = b_ans_0.text
	Data.instant.str_choice_1 = b_ans_1.text
	
	Data.instant.is_timeout = (yourAns == eAnswer.tle)
	if(ansInd == yourAns):
		Data.instant.int_score += 1
		if(Data.instant.int_score == instance_rule.int_max_score):
			Data.instant.is_complete = true
			get_tree().change_scene_to_file("res://Src/Result/Result.tscn")
		else:
			get_tree().change_scene_to_file("res://Src/Stage/Stage.tscn")
	else:
		#b_ans_0.disabled = true;
		#b_ans_1.disabled = true;

		Data.instant.is_complete = false
		get_tree().change_scene_to_file("res://Src/Result/Result.tscn")


func _on_timer_timeout():
	_check_ans(eAnswer.tle)
