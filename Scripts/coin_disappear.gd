extends Node2D


func _on_coin_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$".".queue_free()
