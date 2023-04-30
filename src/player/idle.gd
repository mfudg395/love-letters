extends State

# Reference to the Player that can be in this state. Needed in order to access
# their attributes (adjust velocity, set animation, etc.)
@onready var player: Player
@onready var state_name := "idle"
	
func enter() -> void:
	player.velocity.x = 0
#	player.animations.play("idle")

func physics_process(delta: float) -> void:
	player.sprite.scale.x = 1 if player.is_facing_right else -1
	
	player.velocity.y += player.gravity * delta
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	player.velocity = player.velocity
	
	if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
		return
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.transition_to("Move")
	if Input.is_action_just_pressed("jump"):
		if player.current_stamina >= player.JUMP_STAMINA_COST:
			player.current_stamina -= player.JUMP_STAMINA_COST
			state_machine.transition_to("Jump")
