extends Area2D


@onready var animation_player = get_node("AnimationPlayer")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	animation_player.play("idle")


func _on_body_entered(_body):
	queue_free()
