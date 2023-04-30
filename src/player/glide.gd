extends State

# Reference to the Player that can be in this state. Needed in order to access
# their attributes (adjust velocity, set animation, etc.)
@onready var player: Player
@onready var state_name := "glide"

func enter() -> void:
	pass

func physics_process(delta: float) -> void:
#	player.sprite.flip_h = false if player.is_facing_right else true
	player.sprite.scale.x = 1 if player.is_facing_right else -1
	
	var direction = 1 if player.is_facing_right else -1
	
	player.velocity.x = direction * player.speed
	if player.velocity.y < player.MAX_FALL_SPEED:
		player.velocity.y = player.gravity * delta * 3
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	player.velocity = player.velocity
	
	# Drain stamina during glide
	if player.glide_stamina_timer.is_stopped():
		player.glide_stamina_timer.start(player.GLIDE_STAMINA_INTERVAL)
	
	if player.is_on_floor():
		state_machine.transition_to("Idle")
	if Input.is_action_just_released("jump"):
		state_machine.transition_to("Fall")
	if Input.is_action_just_pressed("jump"):
		if player.current_stamina >= player.JUMP_STAMINA_COST:
			player.current_stamina -= player.JUMP_STAMINA_COST
			state_machine.transition_to("Jump")
	if player.current_stamina <= 0:
		state_machine.transition_to("Fall")

func _on_glide_stamina_timer_timeout():
	player.current_stamina -= player.GLIDE_STAMINA_COST
	# Safety check in case stamina underflows
	if player.current_stamina < 0:
		player.current_stamina = 0
	player.glide_stamina_timer.stop()
