extends Control

@onready var total_points_label: Label = $CenterContainer/Panel/VBoxContainer/totalPoints
@onready var message_label: Label = $CenterContainer/Panel/VBoxContainer/messageLabel
@onready var points_and_bonus_label: Label = $CenterContainer/Panel/VBoxContainer/points
var die : PackedScene = preload("res://die.tscn")

#signal
signal restart_game

var dice_points = 0
var message = ''
var total_points = 0
var bonus_points = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/Control/AnimationPlayer.play("show")
	#$Control/AnimationPlayer.play("show");
	total_points_label.text = str(total_points)
	message_label.text = message
	points_and_bonus_label.text = '(' + str(dice_points) + ' dice points + ' + str(bonus_points) + ' bonus points)'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_dice_face(dice_array):
	for dice in dice_array:
		print(dice)
		var small_dice = die.instantiate();
		small_dice.value = dice
		print(small_dice)
		small_dice.get_node("VBoxContainer/CheckButton").visible = false
		add_child(small_dice)

func _on_button_yes_pressed() -> void:
	restart_game.emit()
