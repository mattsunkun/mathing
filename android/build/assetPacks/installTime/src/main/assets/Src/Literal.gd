extends Node

class clsId:
	var isDebug:bool = false
	
	func banner()->String:
		if isDebug:
			return "ca-app-pub-3940256099942544/2934735716"
		else:
			#print(OS.get_name())
			#return "ca-app-pub-9875500179899216/7416822912" ############################
			if OS.get_name() == 'iOS':
				return "ca-app-pub-9875500179899216/7416822912"
			else:
				return "ca-app-pub-9875500179899216/9012632734"
		
	func interstitial()->String:
		if isDebug:
			return "ca-app-pub-3940256099942544/1033173712"
		else:
			#return "ca-app-pub-9875500179899216/6103741241" ############################
			if OS.get_name() == 'iOS':
				return "ca-app-pub-9875500179899216/6103741241"
			else:
				return "ca-app-pub-9875500179899216/6877820767"
	
	func rewarded()->String:
		if isDebug:
			return "ca-app-pub-3940256099942544/1712485313"
		else:
			if OS.get_name() == 'iOS':
				return "ca-app-pub-9875500179899216/5265356199"
			else:
				return "ca-app-pub-9875500179899216/6031642954"

class clsPath:
	const home:String = "res://Src/Home/Home.tscn"
	const stage:String = "res://Src/Stage/Stage.tscn"
	const result:String = "res://Src/Result/Result.tscn"
	
	const save:String = "user://savegame.save"
	
	# const intTimeLimit:int = 5.0

class clsColor:
	var vGray = Vector3(128, 128, 128)
	var vBrown = Vector3(139, 69, 19)
	var vGreen = Vector3(0, 128, 0)
	var vAqua = Vector3(0, 255, 255)
	var vBlue = Vector3(0, 0, 255)
	
	var v_yellow = Vector3(255, 255, 0)
	var v_orange = Vector3(255, 165, 0)
	var v_red = Vector3(255, 0, 0)
	var v_bronze = Vector3(205, 127, 50)
	var v_silver = Vector3(192, 192, 192)
	var v_gold = Vector3(255, 215, 0)
	
	
	var vs_color:Array = [
		vGray, 
		vBrown, 
		vGreen, 
		vAqua,
		vBlue, 
		v_yellow, 
		v_orange, 
		v_red,
		v_bronze, 
		v_silver, 
		v_gold, 
		
	]
	func _get_color(
		numerator:float, denominator:float, 
		vColorS:Vector3, vColorT:Vector3
		)->Color:
		return Color8(
			int(vColorS.x + (vColorT.x - vColorS.x)*numerator/denominator), 
			int(vColorS.y + (vColorT.y - vColorS.y)*numerator/denominator), 
			int(vColorS.z + (vColorT.z - vColorS.z)*numerator/denominator)
		)
	func get_color(n:float, d:float, kinds:int)->Color:
		# 種類ごとで回す．
		for i in range(kinds-1):
			# その間であったとき
			if(n/d<=(float(i)+1.0)/float(kinds-1)):
				#print("color")
				#print(i)
				# 色を段階で取得
				var c = _get_color(
					n-float(i)*(d/float(kinds-1)), d/float(kinds-1), 
					vs_color[i], vs_color[i+1]
					)
				return c
				
		return Color.BLACK
		
	#func get_beginners_color(
		#n:float, d:float, 
	#)->Color:
		##print("fd")
		##return Color(128, 128, 128, 255)
		## print("heloo")
		#const KIND:int = 4
		#for i in range(KIND):
			#var vColorS:Vector3
			#var vColorT:Vector3
			#if(i==0):
				#vColorS = vGray
				#vColorT = vBrown
			#if(i==1):
				#vColorS = vBrown
				#vColorT = vGreen
			#if(i==2):
				#vColorS = vGreen
				#vColorT = vAqua
			#if(i==3):
				#vColorS = vAqua
				#vColorT = vBlue
			## print((i+1)/float(KIND)
			#if(n/d<=(i+1)/float(KIND)):
				##print("asdf")
				##print(i)
				##print(n/d)
				##print((i+1)/float(KIND))
				#
				#var c = _get_color(
					#n-i*(d/KIND), d/KIND, 
					#vColorS, vColorT
					#)
				#print("color")
				#print(c.r)
				#print(c.g)
				#print(c.b)
				#return c
					#
		#return Color8(255,255,255)
var color = clsColor.new()

enum eRule {
	beginner, 
	regular, 
	grand, 
	impossible, 
	NONE,
}
enum eOperator {
	plus, 
	minus, 
	multiply, 
	divide, 
}
class clsBeginnerRule:
	var rule:eRule = eRule.beginner
	var int_max_score:int = (50 - 10)/2
	var flt_time_limit:float = 30.0
	var int_color_steps:int = 5
	# var int_max_digits:int = 3
	
class clsRegularRule:
	var rule:eRule = eRule.regular
	var int_max_score:int = (80 - 10)/2
	var flt_time_limit:float = 20.0
	var int_color_steps:int = 8
	# var int_max_digits:int = 3
	
class clsGrandRule:
	var rule:eRule = eRule.grand
	var int_max_score:int = (110 - 10)/2
	var flt_time_limit:float = 10.0
	var int_color_steps:int = 11
	# var int_max_digits:int = -1
	
class clsImpossibleRule:
	var rule:eRule = eRule.impossible
	var int_max_score:int = 100
	var flt_time_limit:float = 5.0
	var int_color_steps:int = 11
	# var int_max_digits:int = -1
	
var id = clsId.new()
var path = clsPath.new()
var beginner_rule = clsBeginnerRule.new()
var regular_rule = clsRegularRule.new()
var grand_rule = clsGrandRule.new()
var impossible_rule = clsImpossibleRule.new()
