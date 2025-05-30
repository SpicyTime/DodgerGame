extends Node


func play_sfx(stream: AudioStream, bus: String, volume := 1.0, pitch := 1.0):
	 
	if stream == null:
		 
		return
	
	var sound = AudioStreamPlayer2D.new()
	sound.stream = stream
	sound.bus = bus
	sound.pitch_scale = pitch
	sound.volume_db = linear_to_db(volume)
	add_child(sound)
	
	sound.play()
	sound.connect("finished", Callable(sound, "queue_free"))
