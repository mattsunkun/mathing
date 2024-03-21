extends Node2D

var _interstitial_ad : InterstitialAd

func _ready() -> void:
	#The initializate needs to be done only once, ideally at app launch.
	MobileAds.initialize()

func _on_load_pressed():
#free memory
	if _interstitial_ad:
		#always call this method on all AdFormats to free memory on Android/iOS
		_interstitial_ad.destroy()
		_interstitial_ad = null

	var unit_id : String = Data.instant.str_ad_next
	#if OS.get_name() == "Android":
		#unit_id = "ca-app-pub-3940256099942544/1033173712"
	#elif OS.get_name() == "iOS":
		#unit_id = "ca-app-pub-3940256099942544/4411468910"

	var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
	interstitial_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)

	interstitial_ad_load_callback.on_ad_loaded = func(interstitial_ad : InterstitialAd) -> void:
		print("interstitial ad loaded" + str(interstitial_ad._uid))
		_interstitial_ad = interstitial_ad

	InterstitialAdLoader.new().load(unit_id, AdRequest.new(), interstitial_ad_load_callback)
	_interstitial_ad.show()
	_interstitial_ad.destroy()
	_interstitial_ad = null
	get_tree().change_scene_to_file(Data.instant.str_ad_next)
