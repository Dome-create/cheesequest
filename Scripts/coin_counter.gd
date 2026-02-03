extends Control

@export var player_path: NodePath

@onready var label: Label = $Label

func _ready() -> void:
	var player = get_node_or_null(player_path)
	if player:
		player.coins_changed.connect(_on_coins_changed)
		_on_coins_changed(player.coins)
	else:
		_on_coins_changed(0)

func _on_coins_changed(count: int) -> void:
	label.text = "Coins: %d" % count
