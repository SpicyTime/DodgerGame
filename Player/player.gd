class_name Player
extends CharacterBody2D
@export var speed := 750.0
@onready var health: Health = $Health

var gravity: float = 9.8
var powerups = []
			
		
func add_health(amount):
	powerups.append(Constants.PowerupType.HEALTH)
	health.set_max_health(health.max_health + amount)
	health.restore_health()
	
func _ready()-> void:
	SignalBus.health_depleted.connect(_on_health_depleted)
	
func _physics_process(delta: float) -> void:
	if GameManager.is_paused:
		return
		
	velocity = Vector2.ZERO

	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_just_pressed("shoot"):
		$Gun.shoot()
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity = velocity.normalized() * speed
	
	move_and_slide()
func _on_health_depleted(health_object):
	if health_object == $Health:
		queue_free()
		SignalBus.player_dead.emit()
 		
