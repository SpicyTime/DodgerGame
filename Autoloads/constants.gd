extends Node

enum PowerupType{
	HEALTH 
}
enum PickupType{
	POWERUP,
	COIN,
	AMMO
}
enum FallingObjectSize{
	LARGE,
	MEDIUM,
	SMALL
}
const powerup_root: String = "res://Pickups/Powerups"
const type_to_scene: Dictionary[PowerupType, String] = {
	PowerupType.HEALTH: powerup_root + "/health_pickup.tscn"
}

const SFX_FOLDER_PATH = "res://Assets/Audio/SFX/"
