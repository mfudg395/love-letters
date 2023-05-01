extends State

# Reference to the Player that can be in this state. Needed in order to access
# their attributes (adjust velocity, set animation, etc.)
@onready var player: Player
@onready var state_name := "jump"

func enter() -> void:
	player.velocity.y = player.jump_strength
	player.jump_sfx.play()

func physics_process(delta: float) -> void:
#	player.sprite.flip_h = false if player.is_facing_right else true
	player.sprite.scale.x = 1 if player.is_facing_right else -1
	
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	player.velocity.x = direction * player.speed
	if player.velocity.y < player.MAX_FALL_SPEED:
		player.velocity.y += player.gravity * delta
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	player.velocity = player.velocity
	
	if player.is_on_floor():
		state_machine.transition_to("Idle")
	if player.velocity.y > 0:
		state_machine.transition_to("Fall")
	
