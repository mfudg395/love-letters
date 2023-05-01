extends State

# Reference to the Player that can be in this state. Needed in order to access
# their attributes (adjust velocity, set animation, etc.)
@onready var player: Player
# A string that's used as this state's key in the state machine's dictionary of
# states. Just used for debugging/ease-of-access purposes at the moment.
@onready var state_name := "fall"
const GLIDE_DELAY := 0.05 # Amount of time you must fall for before you can glide, in seconds. Makes controls feel tighter by preventing accidental glides after jumping.
@onready var glide_delay_timer = get_node("GlideDelayTimer")
@onready var can_glide = false

func enter() -> void:
	can_glide = false
	glide_delay_timer.start(GLIDE_DELAY)

func physics_process(delta: float) -> void:
#	player.sprite.flip_h = false if player.is_facing_right else true
	player.sprite.scale.x = 1 if player.is_facing_right else -1
	
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		player.velocity.x = direction * player.speed
	else:
		if player.velocity.x < 3 && player.velocity.x > -3:
			player.velocity.x = 0
		else:
			player.velocity.x = player.velocity.x * player.AIR_DEACCELERATION
	
	if (player.velocity.y < player.MAX_FALL_SPEED):
		player.velocity.y += player.gravity * delta
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	player.velocity = player.velocity
	

	if player.is_on_floor():
		if direction == 0:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Move")
	if Input.is_action_pressed("jump") and player.current_stamina > 0 and can_glide:
		state_machine.transition_to("Glide")
	if Input.is_action_just_pressed("jump"):
		if player.current_stamina >= player.JUMP_STAMINA_COST:
			player.current_stamina -= player.JUMP_STAMINA_COST
			state_machine.transition_to("Jump")


func _on_glide_delay_timer_timeout():
	can_glide = true
	glide_delay_timer.stop()
