class_name Player
extends CharacterBody2D
@export var speed := 750.0
@onready var health: Health = $Health
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun: Node2D = $Gun

var gravity: float = 9.8
var powerups = []
var bullets: int = 500
var gun_flipped 
var coin_count: int = 0
func add_health(amount):
	powerups.append(Constants.PowerupType.HEALTH)
	health.set_max_health(health.max_health + amount)
	health.restore_health()
func add_bullets(amount: int):
	bullets += amount
func add_coin():
	coin_count += 1
func _ready()-> void:
	SignalBus.health_depleted.connect(_on_health_depleted)
	gun_flipped = gun.position.x * -1
	SignalBus.health_changed.connect(_on_health_changed)
func _physics_process(delta: float) -> void:
	if GameManager.is_paused:
		return

	velocity = Vector2.ZERO

	# Handle horizontal input
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
		animated_sprite_2d.flip_h = false
		gun.position.x = -gun_flipped
	elif Input.is_action_pressed("move_right"):
		velocity.x = 1
		animated_sprite_2d.flip_h = true
		gun.position.x = gun_flipped

	# Handle shooting
	if Input.is_action_just_pressed("shoot") and bullets > 0:
		gun.shoot()
		bullets -= 1

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Apply speed
	velocity = velocity.normalized() * speed
	move_and_slide()

	# Animation
	if velocity.x != 0:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
func _on_health_changed(diff, node):
	if node == $Health:
		if diff < 0:
			$HurtSFX.play()
func _on_health_depleted(health_object):
	if health_object == $Health:
		queue_free()
		SignalBus.player_dead.emit()
 		
