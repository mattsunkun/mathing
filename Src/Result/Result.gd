extends Node2D
@onready var cr_background = $crBackground
@onready var l_problem = $lProblem
@onready var b_ans_0 = $bAns0
@onready var b_ans_1 = $bAns1
@onready var l_score = $lScore

@onready var asp_max = $aspMax
@onready var asp_great = $aspGreat
@onready var asp_so_so = $aspSoSo
@onready var asp_timeout = $aspTimeout
@onready var l_message = $lMessage
@onready var b_continue = $bContinue
@onready var b_retry = $bRetry
@onready var b_home = $bHome

var instance_rule = -1

enum eSound{
	max,
	great, 
	so_so, 
	timeout, 
	none, 
}
# Called when the node enters the scene tree for the first time.
func _ready():
	#isRewardReady = false
	b_continue.visible = false
	#b_ans_0.visible = true
	#b_ans_1.visible = true
	int_ready()
	int_on_load_pressed()
	rew_ready()
	rew_on_load_pressed()
	cr_background.color = Data.instant.color_result
	
	var soundType:eSound = eSound.none
	
	soundType = eSound.so_so

		#asp_timeout.volume_db = Data.persist.flt_volume_se
		#asp_timeout.play()
	# rule
	# スコア更新
	if(Data.instant.rule == Literal.eRule.beginner):
		instance_rule = Literal.beginner_rule
		# <=にすることで，maxscoreでgreat音声を出す．<-No
		if(Data.persist.int_max_beginner < Data.instant.int_score):
			soundType = eSound.great
			Data.persist.int_max_beginner = Data.instant.int_score
	if(Data.instant.rule == Literal.eRule.regular):
		instance_rule = Literal.regular_rule
		if(Data.persist.int_max_regular < Data.instant.int_score):
			soundType = eSound.great
			Data.persist.int_max_regular = Data.instant.int_score
	if(Data.instant.rule == Literal.eRule.grand):
		instance_rule = Literal.grand_rule
		if(Data.persist.int_max_grand < Data.instant.int_score):
			soundType = eSound.great
			Data.persist.int_max_grand = Data.instant.int_score
	if(Data.instant.rule == Literal.eRule.impossible):
		instance_rule = Literal.impossible_rule
		if(Data.persist.int_max_impossible < Data.instant.int_score):
			soundType = eSound.great
			Data.persist.int_max_impossible = Data.instant.int_score

	# max
	if(instance_rule.int_max_score == Data.instant.int_score):
		soundType = eSound.max
		
	if(Data.instant.is_timeout and !Data.instant.is_complete):
		soundType = eSound.timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(l_message, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(l_message, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(b_continue, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(b_continue, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_CUBIC)
	
	if(soundType == eSound.max):
		l_message.text = "You Win!! %s!!" % Data.persist.str_user_name
		if(Data.instant.rule == Literal.eRule.impossible):
			l_message.text = "YOU'RE WINNER！"
		tween.tween_property(l_score, "modulate", Color(1,1,1,0), 0.5).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(l_score, "modulate", Color(1,1,1,1), 0.5).set_trans(Tween.TRANS_CUBIC)
		
		asp_max.volume_db = Data.persist.flt_volume_se - 5.0
		asp_max.play()
	if(soundType == eSound.great):
		l_message.text = "%s's highest!!" % Data.persist.str_user_name
		tween.tween_property(l_score, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(l_score, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_CUBIC)
		

		asp_great.volume_db = Data.persist.flt_volume_se - 5.0
		asp_great.play()
	if(soundType == eSound.so_so):
		l_message.text = "Well Done!! %s!!" % Data.persist.str_user_name
		asp_so_so.volume_db = Data.persist.flt_volume_se
		asp_so_so.play()
	if(soundType == eSound.timeout):
		l_message.text = "Time Limit Exceeded!!"
		asp_timeout.volume_db = Data.persist.flt_volume_se - 10.0
		asp_timeout.play()
	
	tween.set_loops()
	
	b_ans_0.disabled = true;
	b_ans_1.disabled = true;
	#b_continue.visible = (Data.instant.int_score != instance_rule.int_max_score) # スコアmaxの時はcontできない
	
	l_problem.text = Data.instant.str_problem
	b_ans_0.text = Data.instant.str_choice_0
	b_ans_1.text = Data.instant.str_choice_1
	
	# 進捗状況
	l_score.text = "%s%s%s"%[
		str(Data.instant.int_score).format("%.3f"),
		"/",
		str(instance_rule.int_max_score)
		]
	
	Data.persist.save_game()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#var int_score:int = 0

func _on_b_retry_pressed():
	# rule 継続
	# Data.instant.rule = rule
	### 一旦削除
	#int_on_show_pressed()
	Data.instant.int_score = 0
	get_tree().change_scene_to_file("res://Src/Start/Start.tscn")
	#Data.instant.str_ad_next = "res://Src/Start/Start.tscn"
	#get_tree().change_scene_to_file("res://Src/Ads/MyInterstitial.tscn")


func _on_b_home_pressed():
	#Data.instant.str_ad_next = "res://Src/Home/Home.tscn"
	#get_tree().change_scene_to_file("res://Src/Ads/MyInterstitial.tscn")
	int_on_show_pressed()
	get_tree().change_scene_to_file("res://Src/Home/Home.tscn")

var is_watched_video:bool = false

func _on_b_continue_pressed():
	
	if(is_watched_video):
		get_tree().change_scene_to_file("res://Src/Start/Start.tscn")
	else:
		rew_on_show_pressed()
		b_retry.visible = false
		b_home.visible = false
		b_ans_0.visible = false
		b_ans_1.visible = false
		b_continue.text = "Continue"
		is_watched_video = true
	#get_tree().change_scene_to_file("res://Src/Start/Start.tscn")
	#get_tree().change_scene_to_file("res://Src/Stage/Stage.tscn")
	#Data.instant.str_ad_next = "res://Src/Stage/Stage.tscn"
	#get_tree().change_scene_to_file("res://Src/Ads/MyRewarded.tscn")


# MIT License

# Copyright (c) 2023-present Poing Studios

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


### Interstitial 
#extends VBoxContainer

var interstitial_ad : InterstitialAd
var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
var full_screen_content_callback := FullScreenContentCallback.new()
#
#@onready var LoadButton := $Load
#@onready var ShowButton := $Show
#@onready var DestroyButton := $Destroy

func int_ready():
	interstitial_ad_load_callback.on_ad_failed_to_load = on_interstitial_ad_failed_to_load
	interstitial_ad_load_callback.on_ad_loaded = on_interstitial_ad_loaded

	full_screen_content_callback.on_ad_clicked = func() -> void:
		print("on_ad_clicked")
	full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
		int_destroy()
		
	full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("on_ad_failed_to_show_full_screen_content")
	full_screen_content_callback.on_ad_impression = func() -> void:
		print("on_ad_impression")
	full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
		print("on_ad_showed_full_screen_content")

func int_on_load_pressed():
	InterstitialAdLoader.new().load(Literal.id.interstitial(), AdRequest.new(), interstitial_ad_load_callback)

func on_interstitial_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_interstitial_ad_loaded(interstitial_ad : InterstitialAd) -> void:
	print("interstitial ad loaded" + str(interstitial_ad._uid))
	interstitial_ad.full_screen_content_callback = full_screen_content_callback
	self.interstitial_ad = interstitial_ad
	#DestroyButton.disabled = false
	#ShowButton.disabled = false
	#LoadButton.disabled = true
	#b_ans_0.visible = false
	#b_ans_1.visible = false

func int_on_show_pressed():
	if interstitial_ad:
		interstitial_ad.show()

func int_on_destroy_pressed():
	int_destroy()

func int_destroy():
	if interstitial_ad:
		interstitial_ad.destroy()
		interstitial_ad = null #need to load again
		#DestroyButton.disabled = true
		#ShowButton.disabled = true
		#LoadButton.disabled = false


# MIT License

# Copyright (c) 2023-present Poing Studios

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

##### Rewarded
#extends VBoxContainer

var rewarded_ad : RewardedAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
#var full_screen_content_callback := FullScreenContentCallback.new()

#@onready var LoadButton := $Load
#@onready var ShowButton := $Show
#@onready var DestroyButton := $Destroy

func rew_ready():
	on_user_earned_reward_listener.on_user_earned_reward = on_user_earned_reward
	
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded

	full_screen_content_callback.on_ad_clicked = func() -> void:
		print("on_ad_clicked")
	full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
		rew_destroy()
		
	full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("on_ad_failed_to_show_full_screen_content")
	full_screen_content_callback.on_ad_impression = func() -> void:
		print("on_ad_impression")
	full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
		print("on_ad_showed_full_screen_content")

func rew_on_load_pressed():
	RewardedAdLoader.new().load(Literal.id.rewarded(), AdRequest.new(), rewarded_ad_load_callback)

func on_rewarded_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_rewarded_ad_loaded(rewarded_ad : RewardedAd) -> void:
	print("rewarded ad loaded" + str(rewarded_ad._uid))
	rewarded_ad.full_screen_content_callback = full_screen_content_callback

	var server_side_verification_options := ServerSideVerificationOptions.new()
	server_side_verification_options.custom_data = "TEST PURPOSE"
	server_side_verification_options.user_id = "user_id_test"
	rewarded_ad.set_server_side_verification_options(server_side_verification_options)

	self.rewarded_ad = rewarded_ad
	b_continue.visible = (Data.instant.int_score != instance_rule.int_max_score) # スコアmaxの時はcontできない
	#b_continue.visible = true
	#DestroyButton.disabled = false
	#ShowButton.disabled = false
	#LoadButton.disabled = true

func rew_on_show_pressed():
	if rewarded_ad:
		rewarded_ad.show(on_user_earned_reward_listener)

func on_user_earned_reward(rewarded_item : RewardedItem):
	print("on_user_earned_reward, rewarded_item: rewarded", rewarded_item.amount, rewarded_item.type)

func rew_on_destroy_pressed():
	rew_destroy()

func rew_destroy():
	if rewarded_ad:
		rewarded_ad.destroy()
		rewarded_ad = null #need to load again
		#DestroyButton.disabled = true
		#ShowButton.disabled = true
		#LoadButton.disabled = false
