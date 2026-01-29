extends CharacterBody2D

signal attack_state(attacking)

# BIG JUMP / CHARGE JUMP
var is_charging_jump := false
var was_in_air := false

const BIG_JUMP_VELOCITY := -1400
const ROTATE_SPEED := 6.0

#attacking valtozok
@onready var attack_hitbox = $AttackHitbox
const ATTACK_TIME = 0.15
var is_attacking = false

#walkin
var dash_direction = 0
const WALK = 200
const JUMP_VELOCITY = -800
const SPRINT = 400
var smol= -400
var hanyszo = 0

#dash, wait is this a reference?!
var can_dash = true
const DASH_SPEED = 1000       # Speed during dash
const DASH_TIME = 0.2       # How long dash lasts (seconds)
const DASH_COOLDOWN = 0.5     # Time before you can dash again
var is_dashing = false
var dash_timer = 1
var dash_cooldown_timer = 0.5

func _physics_process(delta: float) -> void:
	# gravity.
	if not is_on_floor():
		velocity += (get_gravity() * 1.3) * delta + Vector2(0, 20)
	# --- AIR → LAND DETECTION ---
		was_in_air = true
	elif was_in_air:
		# just landed
		if Input.is_action_pressed("springy"):
			is_charging_jump = true
			velocity = Vector2.ZERO
		was_in_air = false

	# --- NORMAL JUMP ---
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_charging_jump:
		velocity.y = JUMP_VELOCITY
	# --- BIG JUMP RELEASE ---
	if is_charging_jump and Input.is_action_just_released("springy"):
		is_charging_jump = false
		velocity.y = BIG_JUMP_VELOCITY
		
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		hanyszo += 1
		if hanyszo <= 3:
			velocity.y = smol
	# --- CHARGING STATE ---
	if is_charging_jump:
		velocity.x = 0
		move_and_slide()
		return
		
	if is_on_floor():
		hanyszo = 0
		can_dash = true

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

	if Input.is_action_just_pressed("dive") and dash_cooldown_timer <= 0 and can_dash:
		can_dash = false
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
		$SandorExport.scale.x = direction * 0.5

	#groundpound
	move_and_slide()
	
func start_attack():
	is_attacking = true
	emit_signal("attack_state", is_attacking)

	# Position hitbox in front of player
	$AttackHitbox.position.x = 40 * sign($SandorExport.scale.x)
	await get_tree().create_timer(ATTACK_TIME).timeout
	$AttackHitbox.position.x = 0 * sign($SandorExport.scale.x)

	is_attacking = false
	emit_signal("attack_state", is_attacking)
