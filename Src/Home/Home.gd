extends Node2D

@onready var cr_background = $crBackground
@onready var b_beginner = $bBeginner 
@onready var b_regular = $bRegular
@onready var b_grand = $bGrand
@onready var b_impossible = $bImpossible

@onready var le_user_name = $leUserName

@onready var se_asp_check = $pSE/aspCheck
@onready var se_hsb = $pSE/hsb
@onready var se_l_no = $pSE/lNo

var _ad_view : AdView

func _ready():
	## 一回だけ実行する必要があるらしいからどうしようね．
	##The initializate needs to be done only once, ideally at app launch.
	#MobileAds.initialize()
	#init(isReal, instance_id)
	
	
	
	
	# データロード
	Data.persist.load_game()
	
	# 音
	se_hsb.value = Data.persist.flt_volume_se
	# _on_hsb_se_scrolling(true)
	# _on_hsb_se_changed()
	changeVol(true)
	# 背景灰色
	cr_background.color = Color8(128,128,128)# Literal.color.vGray
	# b_beginner.color
	le_user_name.text = Data.persist.str_user_name
	if(le_user_name.text == ""):
		le_user_name.text = "名無し"
		
	b_beginner.add_theme_color_override("font_color", 
		Literal.color.get_color(
			Data.persist.int_max_beginner, 
			Literal.beginner_rule.int_max_score, 
			Literal.beginner_rule.int_color_steps, 
		)
	)
	b_regular.add_theme_color_override("font_color", 
		Literal.color.get_color(
			Data.persist.int_max_regular, 
			Literal.regular_rule.int_max_score, 
			Literal.regular_rule.int_color_steps, 
		)
	)
	b_grand.add_theme_color_override("font_color", 
		Literal.color.get_color(
			Data.persist.int_max_grand, 
			Literal.grand_rule.int_max_score, 
			Literal.grand_rule.int_color_steps, 
		)
	)
	b_impossible.add_theme_color_override("font_color", 
		Literal.color.get_color(
			Data.persist.int_max_impossible, 
			Literal.impossible_rule.int_max_score, 
			Literal.impossible_rule.int_color_steps, 
		)
	)
	# has_theme_color_override("font_color", "bBeginner", Color.RED)
	# impossible利用可能
	b_impossible.visible = (
	
		(Data.persist.int_max_beginner == Literal.beginner_rule.int_max_score) and 
		(Data.persist.int_max_regular == Literal.regular_rule.int_max_score) and
		(Data.persist.int_max_grand == Literal.grand_rule.int_max_score)
	)
	#
#func _create_ad_view() -> void:
	##free memory
	##if _ad_view:
		##destroy_ad_view()
	#print("ASAASADFASDF")
	#var unit_id : String
	#if OS.get_name() == "Android":
		#unit_id = "ca-app-pub-3940256099942544/6300978111"
	#elif OS.get_name() == "iOS":
		#unit_id = "ca-app-pub-3940256099942544/2934735716"
#
	#_ad_view = AdView.new(unit_id, AdSize.BANNER, AdPosition.Values.TOP)
	
	
	#le_user_name.text = "%s %s"%[OS.get_name()=="Android",(OS.get_name()=="iOS")]
	#b_beginner.text = OS.get_name()
	#print(OS.get_name()=='macOS')

func _start_game(rule:Literal.eRule):
	Data.instant.rule = rule
	Data.instant.int_score = 0
	Data.persist.str_user_name = le_user_name.text
	Data.instant.is_cheet = le_user_name.text.begins_with("{hat}")
	Literal.id.isDebug = le_user_name.text.ends_with("{deb}")
	Data.persist.save_game()
	get_tree().change_scene_to_file("res://Src/Start/Start.tscn")
	#get_tree().change_scene_to_file("res://addons/admob/sample/Rewarded.tscn")
	#get_tree().change_scene_to_file("res://addons/admob/sample/Main.tscn")
	#get_tree().change_scene_to_file("res://addons/admob/sample/Interstitial.tscn")

func _on_beginner_button_pressed():
	#get_tree().change_scene_to_file("res://addons/admob/sample/Main.tscn")
	#return
	_start_game(Literal.eRule.beginner)


func _on_regular_button_pressed():
	_start_game(Literal.eRule.regular)


func _on_grand_button_pressed():
	_start_game(Literal.eRule.grand)


func _on_impossible_button_pressed():
	_start_game(Literal.eRule.impossible)


#func _on_hsb_se_changed():
	#var _fltMin:float = -10.0
	#var _fltMax:float = 10.0
	#var _fltERROR:float = 0.001
	#var fltDb = hsb_se.value
	#if(fltDb < _fltMin + _fltERROR):
		#fltDb = _fltMin
	#if(_fltMax + _fltERROR < fltDb):
		#fltDb = _fltMax
	#Data.persist.flt_volume_se = fltDb
	#Sound.se(load("res://Assets/Sounds/pin.ogg"))
	#print("sound!!")


func _on_hsb_se_scrolling(mute:bool=false):
	changeVol(false)
func changeVol(silent:bool):
	var _fltMute:float = -80.0
	var _fltMin:float = se_hsb.min_value# -30.0
	var _fltMax:float = se_hsb.max_value
	var _fltERROR:float = 0.001
	var fltDb = se_hsb.value
	if(fltDb < _fltMin + _fltERROR):
		fltDb = _fltMin
		fltDb = _fltMute
		se_l_no.visible = true
	else:
		se_l_no.visible = false
	if(_fltMax + _fltERROR < fltDb):
		fltDb = _fltMax
	Data.persist.flt_volume_se = fltDb
	
	se_asp_check.volume_db = Data.persist.flt_volume_se
	if(!silent):
		se_asp_check.play()
	#var audio_stream = AudioStreamOggVorbis.new()
	#audio_stream.load("res://Assets/Sounds/pin.ogg")
	# var audio_stream = AudioStreamGenerator.new()
	#audio_stream.format = AudioStreamSample.FORMAT_16_BITS
	#audio_stream.mix_rate = 44100
	#audio_stream.channels = 2
	#audio_stream = preload("res://path_to_script_that_generates_audio.gd")
	#Sound.se(preload(("res://Assets/Sounds/pin.ogg")))
	#print("sound!!")
	#print(fltDb)


func _on_hsb_value_changed(value):
	# changeVol(false)
	pass
