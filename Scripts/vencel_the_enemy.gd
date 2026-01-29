extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.get_node("Health").take_damage(10)
