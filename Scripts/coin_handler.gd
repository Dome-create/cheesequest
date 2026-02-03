extends Node2D

var coins := 0

func _on_coin_detector_area_entered(area: Area2D) -> void:
	if area.name == "coin":
		coins += 1
		$"../CanvasGroup/Label".text = str(coins)
