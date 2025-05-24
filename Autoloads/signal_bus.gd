extends Node
#Health System
signal health_changed(diff: int)
signal max_health_changed(diff: int)
signal received_damage(damage: int)
signal health_depleted

#Hud
signal score_changed(new_score: int)

#Player
signal player_dead
