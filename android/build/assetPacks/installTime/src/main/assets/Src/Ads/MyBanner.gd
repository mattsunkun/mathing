extends Node


var ad_view : AdView
var ad_listener := AdListener.new()
var adPosition := AdPosition.Values.BOTTOM


# Called when the node enters the scene tree for the first time.
func _ready():

	if ad_view:
		ad_view.destroy() #always try to destroy the ad_view if won't use anymore to clear memory

	var adSizecurrent_orientation := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	print("adSizecurrent_orientation: ", adSizecurrent_orientation.width, ", ", adSizecurrent_orientation.height)
	var adSizeportrait := AdSize.get_portrait_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	print("adSizeportrait: ", adSizeportrait.width, ", ", adSizeportrait.height)
	var adSizelandscape := AdSize.get_landscape_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	print("adSizelandscape: ", adSizelandscape.width, ", ", adSizelandscape.height)
	var adSizesmart := AdSize.get_smart_banner_ad_size()
	print("adSizesmart: ", adSizesmart.width, ", ",adSizesmart.height)
	ad_view = AdView.new(Literal.id.banner(), adSizecurrent_orientation, adPosition)
	ad_view.ad_listener = ad_listener
	var ad_request := AdRequest.new()
	var vungle_mediation_extras := VungleInterstitialMediationExtras.new()
	vungle_mediation_extras.all_placements = ["placement1", "placement2"]
	vungle_mediation_extras.sound_enabled = true
	vungle_mediation_extras.user_id = "testuserid"
	
	var ad_colony_mediation_extras := AdColonyMediationExtras.new()
	ad_colony_mediation_extras.show_post_popup = false
	ad_colony_mediation_extras.show_pre_popup = true
	ad_request.mediation_extras.append(vungle_mediation_extras)
	ad_request.mediation_extras.append(ad_colony_mediation_extras)
	ad_request.keywords.append("21313")
	ad_request.extras["ID"] = "value"

	ad_view.load_ad(ad_request)
