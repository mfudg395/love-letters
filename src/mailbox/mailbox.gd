extends Area2D

const MAX_LETTERS := 5

@export var deposited_letters := 0

@onready var play_animation = true
@onready var deposited_letters_indicator = get_node("DepositedLettersIndicator")
@onready var sprite = get_node("Sprite2D")
@onready var animation_player = get_node("AnimationPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	deposited_letters_indicator.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	deposited_letters_indicator.text = str(deposited_letters) + "/5"
	if (deposited_letters == MAX_LETTERS and play_animation):
		animation_player.play("mailbox_full")

func _on_area_entered(area):
	if (area.get_name() == "MailboxDetection"):
		deposited_letters_indicator.visible = true

func _on_area_exited(area):
	if (area.get_name() == "MailboxDetection"):
		deposited_letters_indicator.visible = false


func _on_animation_player_animation_finished(_anim_name):
	animation_player.stop()
	sprite.frame = 5
	play_animation = false

func deposit_letter():
	deposited_letters += 1

func is_full() -> bool:
	return deposited_letters == MAX_LETTERS
