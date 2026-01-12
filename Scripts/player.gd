extends CharacterBody2D


const WALK = 200
const JUMP_VELOCITY = -800
const SPRINT = 400
const DASH_SPEED = 800        # Speed during dash
const DASH_TIME = 0.2         # How long dash lasts (seconds)
const DASH_COOLDOWN = 0.5     # Time before you can dash again

var is_dashing = false
var dash_timer = 1
var dash_cooldown_timer = 0.5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += (get_gravity() * 1.5) * delta + Vector2(0, 20)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# Horizontal input
	# Dash logic
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	if Input.is_action_just_pressed("dive") and dash_cooldown_timer <= 0:
		is_dashing = true
		dash_timer = DASH_TIME
		dash_cooldown_timer = DASH_COOLDOWN
	var direction := Input.get_axis("left", "right")
	if is_dashing:
		velocity.x = direction * DASH_SPEED
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	else:
		if Input.is_action_pressed("sprint"):
			velocity.x = direction * SPRINT
		else:
			velocity.x = direction * WALK
# Get the input direction and handle the movement/deceleration.
	if direction != 0:
		$SandorExport.scale.x = direction
	move_and_slide()
