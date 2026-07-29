extends Control

@onready var total_points_label: Label = $Control/totalPoints
@onready var message_label: Label = $Control/messageLabel
@onready var points_and_bonus_label: Label = $Control/points

#signal
signal restart_game

var dice_points = 0
var message = ''
var total_points = 0
var bonus_points = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/AnimationPlayer.play("show");
	total_points_label.text = str(total_points)
	message_label.text = message
	points_and_bonus_label.text = '(' + str(dice_points) + ' dice points + ' + str(bonus_points) + ' bonus points)'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_yes_pressed() -> void:
	restart_game.emit()
