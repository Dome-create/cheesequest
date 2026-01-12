extends Node

@export var max_health: int = 100
var health: int

signal health_changed(current: int, max: int)
signal died

func _ready():
	health = max_health
	emit_signal("health_changed", health, max_health)

func take_damage(amount: int):
	if amount <= 0:
		return

	health -= amount
	health = max(health, 0)
	emit_signal("health_changed", health, max_health)

	if health <= 0:
		die()

func heal(amount: int):
	if amount <= 0:
		return

	health += amount
	health = min(health, max_health)
	emit_signal("health_changed", health, max_health)

func die():
	emit_signal("died")
	health = max_health
	get_tree().change_scene_to_file("res://Scenes/menus/death_screen.tscn")
