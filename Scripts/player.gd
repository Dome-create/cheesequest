extends CharacterBody2D
#attacking valtozok
@onready var attack_hitbox = $attackhitbox
const ATTACK_TIME = 0.15
var is_attacking = false

var dash_direction = 0
const WALK = 200
const JUMP_VELOCITY = -800
const SPRINT = 400
const DASH_SPEED = 1000       # Speed during dash
const DASH_TIME = 0.2       # How long dash lasts (seconds)
const DASH_COOLDOWN = 0.5     # Time before you can dash again

var is_dashing = false
var dash_timer = 1
var dash_cooldown_timer = 0.5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += (get_gravity() * 1.3) * delta + Vector2(0, 20)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()

		
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene_to_file("res://Scenes/menus/Main_Menu.tscn")
	
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
		dash_direction = Input.get_axis("left", "right")

	# fallback if no input (dash facing direction)
	if dash_direction == 0:
		dash_direction = sign($SandorExport.scale.x)
	var direction := Input.get_axis("left", "right")
	if is_dashing:
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	else:
		if Input.is_action_pressed("sprint"):
			velocity.x = direction * SPRINT
		else:
			velocity.x = direction * WALK
# Get the input direction and handle the movement/deceleration.
	if Input.is_action_pressed("down") and Input.is_action_pressed("attack") and not is_on_floor():
		velocity.y = 1400
		
	#sprite direction
	if direction != 0:
		$SandorExport.scale.x = direction
	#groundpound
	move_and_slide()
	
func start_attack():
	is_attacking = true
	attack_hitbox.monitoring = true

	# Position hitbox in front of player
	attack_hitbox.position.x = 40 * sign($SandorExport.scale.x)

	await get_tree().create_timer(ATTACK_TIME).timeout

	attack_hitbox.monitoring = false
	is_attacking = false
	

	
