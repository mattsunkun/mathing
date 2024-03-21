extends Node


	
class clsPersist:
	var _ke_user_name:String = "user_name"
	var _ke_max_score:String = "max_score"
	var _ke_volume_se:String = "volume_se"
	var _ke_volume_bgm:String = "volume_bgm"
	
	var str_user_name:String = ""
	# var int_max_score:int = 0
	var int_max_beginner:int = 0
	var int_max_regular:int = 0
	var int_max_grand:int = 0
	var int_max_impossible:int = 0
	
	var flt_volume_se:float = 1.0
	var flt_volume_bgm:float = 1.0
	
	var _str_target_path:String = "user://savegame.save"
		
	func load_game():
		if not FileAccess.file_exists(_str_target_path):
			return
		
		var file = FileAccess.open(_str_target_path, FileAccess.READ)
		var load_data = file.get_var()
		if(load_data == null):
			return
		if(_ke_user_name in load_data):
			str_user_name = load_data[_ke_user_name]

		if(_ke_max_score in load_data):
			# 100,100,100,100, impos,grand,regular,beg
			var int_all_max = int(load_data[_ke_max_score])
			int_max_beginner = (int_all_max)%1000
			int_max_regular = (int_all_max/1000)%1000
			int_max_grand = (int_all_max/1000_000)%1000
			int_max_impossible = (int_all_max/1000_000_000)%1000
		
		if(_ke_volume_se in load_data):
			flt_volume_se = load_data[_ke_volume_se]
		if(_ke_volume_bgm in load_data):
			flt_volume_bgm = load_data[_ke_volume_bgm]
		
		file.close()
	func save_game():
		#var diData = {
			#"strUserName": strUserName, 
			#"intMaxScore": intMaxScore, 
		#}
		var file = FileAccess.open(_str_target_path, FileAccess.WRITE)
		file.store_var({
			_ke_user_name: str_user_name, 
			_ke_max_score: 
				int_max_beginner+
				(int_max_regular*1000)+
				(int_max_grand*1000_000)+
				(int_max_impossible*1000_000_000), 
			_ke_volume_se: flt_volume_se, 
			_ke_volume_bgm: flt_volume_bgm, 
		})
		file.close()
		
	
class clsInstant:
	var rule:Literal.eRule = Literal.eRule.NONE
	var int_score:int = -1
	var str_problem:String = ""
	var str_choice_0:String = ""
	var str_choice_1:String = ""
	var is_complete:bool = false
	var is_timeout:bool = false
	var is_cheet:bool = false
	var color_result:Color = Color.GRAY
	
	var str_ad_next:String = ""
	
	
var persist = clsPersist.new()
var instant = clsInstant.new()


