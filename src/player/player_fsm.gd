class_name PlayerFSM
extends Node

@export var initial_state := NodePath()
@onready var current_state: State = get_node("Idle")
@onready var label = get_node("../StateLabel")
# Dictionary where state names will correspond to their respective
# state objects. Just used for debugging right now.
@onready var states = {}
@onready var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Every state has a reference to the state machine that it will use.
	# This is where this state machine (self) is assigned to states that
	# the player can be in.
	for child in get_children():
		states[child.state_name] = child
		child.state_machine = self

# This is called in Player's _ready() function. It's important to wait until
# then to "initiate" the state machine because otherwise, the states will try 
# to set Player's attributes while it's still null (i.e. before it's finished 
# loading). This was a problem that I wracked my brain over for hours.
func init(player: Player) -> void:
	for child in get_children():
		child.player = player
	self.player = player
	current_state.enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _physics_process(delta) -> void:
	if current_state == states["idle"]:
		label.text = "Idle"
	elif current_state == states["move"]:
		label.text = "Move"
	elif current_state == states["jump"]:
		label.text = "Jump"
	elif current_state == states["fall"]:
		label.text="Fall"
	elif current_state == states["glide"]:
		label.text = "Glide"
	player.animations.play(current_state.state_name)
	
	if current_state == states["idle"] or current_state == states["move"]:
		if player.current_stamina < player.max_stamina and player.stamina_regen_timer.is_stopped():
			player.stamina_regen_timer.start(player.STAMINA_REGEN_INTERVAL)
	current_state.physics_process(delta)
	

# Handles moving from one state to another. The current state is exited, then
# changed to whatever new state is being passed in.
func transition_to(new_state: String) -> void:
	# Safety check - if the passed in state does not exist, we won't try to
	# transition to it.
	if not has_node(new_state):
		return
	current_state.exit() # exit current state
	current_state = get_node(new_state) # update current state with new state
	current_state.enter() # begin new state


func _on_stamina_regen_timer_timeout():
	player.current_stamina += player.STAMINA_REGEN_RATE
	if player.current_stamina > player.max_stamina:
		player.current_stamina = player.max_stamina
	player.stamina_regen_timer.stop()
