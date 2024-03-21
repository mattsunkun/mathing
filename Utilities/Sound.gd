extends Node# AudioStreamPlayer

func se(streamSound:AudioStreamOggVorbis, flt_volume_se:float=Data.persist.flt_volume_se):
	var _asp = AudioStreamPlayer.new()
	print(streamSound)
	_asp.stream = streamSound
	_asp.volume_db = flt_volume_se
	_asp.play()
	print("asdf")
	
class clsSound:
	var _asp:AudioStreamPlayer
	
	func _init(strSoundPath:String):
		_asp = AudioStreamPlayer.new()
		_asp.stream = load(strSoundPath)
		_asp.volume_db = Data.persist.flt_volume_se
		
	var _fltMin:float = -10.0
	var _fltMax:float = 10.0
	var _fltERROR:float = 0.001
	func volume(fltDb:float):
		if(fltDb < _fltMin + _fltERROR):
			fltDb = _fltMin
		if(_fltMax + _fltERROR < fltDb):
			fltDb = _fltMax
		_asp.volume_db = fltDb
		
	func play():
		# 音を出さない
		if(abs(_asp.volume_db - _fltMin) < _fltERROR):
			return
		if(_asp.playing):
			return
		_asp.play()
		
	func repeat():
		pass
	
#class clsBGM:
	#var _asp = AudioStreamPlayer.new()
	#
	#func play():
		#if(_asp.playing):
			#return
		#_asp.play()
	#func stop():
		#if(_asp.playing):
			#_asp.stop()
			#
	#func repeat():
		#pass
	
	
