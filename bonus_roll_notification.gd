extends Control

@onready var label : Label = $Label
@onready var animation : AnimationPlayer = $AnimationPlayer

func show_notification():
	animation.play("up_and_gone")
