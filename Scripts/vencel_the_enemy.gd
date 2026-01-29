extends Area2D

var can_damage := false
var enemy_health :int
@export var max_health := 25

func _ready() -> void:
	enemy_health = max_health
	$".".visible = true
	$VencelHealth.max_value = max_health
	$VencelHealth.value = enemy_health

func die():
	print("Died")
	$"..".queue_free()

func damage(amount :int):
	print("Enemy took " + str(amount) + " damage")
	enemy_health -= amount
	enemy_health = max(enemy_health, 0)
	$VencelHealth.value = enemy_health
	
	if enemy_health <= 0:
		die()

func _on_body_entered(body):
	if body.name == "Player":
		body.get_node("Health").take_damage(10)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "AttackHitbox" and can_damage:
		damage(5)

func _on_player_attack_state(attacking: Variant) -> void:
	can_damage = attacking
