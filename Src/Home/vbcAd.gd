extends "res://addons/admob/sample/Banner.gd"


var _ad_view : AdView

func _ready():
	# 一回だけ実行する必要があるらしいからどうしようね．
	#The initializate needs to be done only once, ideally at app launch.
	#MobileAds.initialize()
	#init(isReal, instance_id)
	
	#var ad = get_node()
	pass
	
func _on_load_banner_pressed() ->void:
	print("asdf")
#func _create_ad_view() -> void:
	##free memory
	#if _ad_view:
		#destroy_ad_view()
		#
	#print("ASAASADFASDF")
	#var unit_id : String
	#if OS.get_name() == "Android":
		#unit_id = "ca-app-pub-3940256099942544/6300978111"
	#elif OS.get_name() == "iOS":
		#unit_id = "ca-app-pub-3940256099942544/2934735716"
#
	#_ad_view = AdView.new(unit_id, AdSize.BANNER, AdPosition.Values.TOP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
