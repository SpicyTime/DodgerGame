extends Node2D
@onready var marker_2d: Marker2D = $Marker2D

func shoot():
	var bullet = load("res://Weapons/bullet.tscn").instantiate()
	get_tree().root.add_child(bullet)
	 
	bullet.position = marker_2d.global_position
	bullet.direction = Vector2(0, -1)
	
