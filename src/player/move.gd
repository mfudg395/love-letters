extends State

# Reference to the Player that can be in this state. Needed in order to access
# their attributes (adjust velocity, set animation, etc.)
@onready var player: Player
# A string that's used as this state's key in the state machine's dictionary of
# states. Just used for debugging/ease-of-access purposes at the moment.
@onready var state_name := "move"

#func enter() -> void:
#	player.animations.play("move") 

func handle_input() -> void:
	pass

func physics_process(delta: float) -> void:
#	player.sprite.flip_h = false if player.is_facing_right else true
	player.sprite.scale.x = 1 if player.is_facing_right else -1
	
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	player.velocity.x = direction * player.speed
	
	player.velocity.y += player.gravity * delta
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	player.velocity = player.velocity
	
	if direction == 0:
		state_machine.transition_to("Idle")
	if Input.is_action_pressed("jump"):
		if player.current_stamina >= player.JUMP_STAMINA_COST:
			player.current_stamina -= player.JUMP_STAMINA_COST
			state_machine.transition_to("Jump")
