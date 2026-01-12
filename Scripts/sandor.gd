extends CharacterBody2D


const WALK = 200
const JUMP_VELOCITY = -400.0
const SPRINT = 400

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if Input.is_action_pressed("sprint"):
		velocity.x = direction * SPRINT
	else:
		velocity.x = direction * WALK
# Get the input direction and handle the movement/deceleration.
	if direction != 0:
		$SandorExport.scale.x = direction
	move_and_slide()
