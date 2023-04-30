class_name Player
extends CharacterBody2D

const MAX_FALL_SPEED := 125
const AIR_DEACCELERATION := 0.99
const JUMP_STAMINA_COST := 25
const GLIDE_STAMINA_COST := 1 # stamina drain per GLIDE_STAMINA_INTERVAL
const GLIDE_STAMINA_INTERVAL := 0.1 # how often to drain stamina by GLIDE_STAMINA_COST when gliding, in seconds
const STAMINA_REGEN_RATE := 2 # stamina to regen per STAMINA_REGEN_INTERVAL
const STAMINA_REGEN_INTERVAL := 0.025 # how often to increase stamina by STAMINA_REGEN_RATE, in seconds

@export var gravity := 635.0
# Lift is an upward force that counteracts the downward force of gravity.
# Vertical velocity will be multiplied by this in the Glide state.
@export var lift := 4
@export var speed := 150.0
@export var jump_strength := -400.0
@export var max_stamina := 50
@export var current_stamina := 50
@onready var letters := 0
@onready var is_near_mailbox := false
@onready var near_mailbox_letters := 0
@onready var full_mailboxes := 0
@onready var near_mailbox: Area2D

@onready var animations = get_node("AnimationPlayer")
@onready var sprite = get_node("Sprite2D")
@onready var state_machine = get_node("PlayerFSM")
@onready var stamina_bar = get_node("StaminaBar")
@onready var stamina_regen_timer = get_node("StaminaRegenTimer")
@onready var glide_stamina_timer = get_node("GlideStaminaTimer")
@onready var letter_label = get_node("LetterLabel")
@onready var mailbox_label = get_node("MailboxLabel")

var is_facing_right := true
var is_pecking := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.init(self)

# Called every frame. 'delta' is the elapsed time since the prDevious frame.
func _process(delta) -> void:
	state_machine._process(delta)
	letter_label.text = str(letters)
	mailbox_label.text = str(full_mailboxes) + "/5"

func _physics_process(delta) -> void:
	if Input.is_action_just_pressed("peck"):
		animations.play("peck")
	
	if Input.is_action_pressed("move_right"):
		is_facing_right = true
	elif Input.is_action_pressed("move_left"):
		is_facing_right = false
	state_machine._physics_process(delta)
	stamina_bar.value = current_stamina
	if current_stamina == max_stamina:
		stamina_bar.visible = false
	else:
		stamina_bar.visible = true
	
	if (can_deposit()):
		if Input.is_action_just_pressed("deliver"):
			letters -= 1
			near_mailbox.deposit_letter()
			if near_mailbox.is_full():
				full_mailboxes += 1

func _on_area_2d_area_entered(area):
	if ("Letter" in area.get_name()):
		letters += 1;
	if ("Mailbox" in area.get_name()):
		is_near_mailbox = true
		near_mailbox = area

func _on_area_2d_area_exited(area):
	if ("Mailbox" in area.get_name()):
		is_near_mailbox = false
		near_mailbox = null

func can_deposit() -> bool:
	return is_near_mailbox and letters > 0 and !near_mailbox.is_full()
