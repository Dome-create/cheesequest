extends Area2D

@export var max_health = 50
var health = max_health
@onready var health_bar = $ProgressBar


func _ready():
	health_bar.max_value = max_health
	health_bar.value = health

func _on_body_entered(body):
	if body.name == "Player":
		body.get_node("Health").take_damage(10)

func take_damage(amount: int):
	health -= amount
	health_bar.value = health

	if health <= 0:
		queue_free()
func _on_area_entered(area):
	if area.name == "attackhitbox":
		print("entered")
		take_damage(10)
