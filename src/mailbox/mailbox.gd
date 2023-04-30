extends Area2D

const MAX_LETTERS := 5

@export var deposited_letters := 0

@onready var deposited_letters_indicator = get_node("DepositedLettersIndicator")


# Called when the node enters the scene tree for the first time.
func _ready():
	deposited_letters_indicator.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deposited_letters_indicator.text = str(deposited_letters) + "/5"

func _on_area_entered(area):
	if (area.get_name() == "MailboxDetection"):
		deposited_letters_indicator.visible = true

func _on_area_exited(area):
	if (area.get_name() == "MailboxDetection"):
		deposited_letters_indicator.visible = false
