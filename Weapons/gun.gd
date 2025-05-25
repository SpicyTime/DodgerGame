extends Node2D
@onready var marker_2d: Marker2D = $Marker2D

func shoot():
	var bullet = load("res://Weapons/bullet.tscn").instantiate()
	get_tree().root.add_child(bullet)
	 
	bullet.position = marker_2d.global_position
	bullet.direction = Vector2(0, -1)
	# Play sound without cutting previous ones
	var sfx = AudioStreamPlayer2D.new()
	sfx.stream = $ShootSFX.stream  # reuse the existing sound
	sfx.global_position = marker_2d.global_position
	sfx.bus = $ShootSFX.bus
	get_tree().root.add_child(sfx)
	sfx.play()

	# Queue free after sound ends
	sfx.connect("finished", Callable(sfx, "queue_free"))
