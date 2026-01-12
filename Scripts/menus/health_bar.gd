extends ProgressBar

@onready var health_node := $"../../Health"

func _ready():
	max_value = health_node.max_health
	value = health_node.health
	
	health_node.health_changed.connect(_on_health_changed)

func _on_health_changed(current: int, max: int):
	max_value = max
	value = current
