extends Panel

@onready var showPoints: Label = get_node("MarginContainer/VBoxContainer/dataContainer/PipsContainer/points")
@onready var bonusPoints: Label = get_node("MarginContainer/VBoxContainer/dataContainer/bonusContainer/bonusPoints")
@onready var rollText : Label = get_node("MarginContainer/VBoxContainer/rollsContainer/rollNumber");
@onready var totalPoints: Label = $%totalPoints
@onready var rollButton : Button = $MarginContainer/VBoxContainer/buttonContainer/rollButton
@onready var bonus_roll_notification = %BonusRoll

@export var game_over_screen : PackedScene
var dice_node_array = []
var test_mode: bool = false;
var num_of_tries: int = 3
var roll_num: int = 0
var extra_roll: int = 0
var sum_dice = 0
var frequency_array: Array[int] = []

var bonus_value = 0
var bonus_message = ''
var total_points = 0

func _ready() -> void:
	new_game()

func new_game():
	num_of_tries= 3
	roll_num = 0
	frequency_array.resize(6)
	frequency_array.fill(0)
	
func _on_roll_button_pressed() -> void:
	get_dice()
	if roll_num < num_of_tries:
		for dice in dice_node_array:
			if dice.locked == false:
				dice.roll()
			sum_points(dice.value)
		update_points_label(sum_dice)
		num_of_tries += extra_roll
		sum_dice = 0
		frequency_array.fill(0)
		roll_num += 1
		rollText.set_text(var_to_str(roll_num)+'/'+var_to_str(num_of_tries));
	if roll_num >= num_of_tries:
		game_over()
	
func get_dice():
	if !test_mode:
		dice_node_array = %diceContainer.find_children("Dice*");
	else:
		dice_node_array = [{"value": 0 , "locked": false},
		{"value": 0 , "locked": false},
		{"value": 0 , "locked": false},
		{"value": 0 , "locked": false},
		{"value": 0 , "locked": false}, ]

func sum_points(pips):
	sum_dice += pips

func update_points_label(sum):
	if roll_num >= num_of_tries:
		var bonus = check_dice()
		bonus_message = bonus.message
		bonus_value = bonus.value
	else: 
		check_pairs()
	showPoints.set_text(var_to_str(sum))
	
func get_frequency_array():
	
	for i in range(0, dice_node_array.size()):
		
		if roll_num >= num_of_tries:
			frequency_array[dice_node_array[i].value-1] += 1;
		else:
			if dice_node_array[i].locked == false:
				frequency_array[dice_node_array[i].value-1] += 1;
		
func check_pairs():
	extra_roll = 0
	get_frequency_array()
	for times in frequency_array:
		if times >= 3:
			extra_roll += times / 3
			bonus_roll_notification.show_notification()
	
func check_dice():
	var sequence: bool = false
	var count: int = 0
	var count_pairs: int = 0
	var pairs = 0
	var pairs_unlocked: int  = 0
	var three_dice = 0;
	var four_dice = 0
	var sequenceMinor = 0
	var SequenceMajor = 0
	var five_dice = 0
	var full_house = 0
	
	#get_frequency_array()
	
	for i in range(0, dice_node_array.size()):
		frequency_array[dice_node_array[i].value-1] += 1;
	
	for numbers in frequency_array:
		match numbers:
			2: pairs += 1
			3: three_dice += 1
			4: four_dice +=1
			5: five_dice += 1
	
	if roll_num >= num_of_tries:
		return check_bonus(count, pairs,three_dice, four_dice,five_dice, full_house, sequence)
	

func check_bonus(count, pairs,three_dice, four_dice,five_dice, full_house, sequence):
	var bonus = { "value": 0, "message": ""}
	#check bonus points
	#1. Dois dados iguais: 5 pontos
	#2. Dois pares: 10 pontos
	#3. Trinca: 15 pontos
	#4. Sequencia menor: 25 pontos
	#5. Sequencia maior: 35 Pontos
	#6. Full house: 50
	#7. Quadra: 60
	#8. Todos dados iguais: 80 pontos
	if count == dice_node_array.size() - 1:
		sequence = true;
	if sequence:
		if dice_node_array[0].value==1:
			bonus.value = 25
			bonus.message = "A minor sequence"
		else:
			bonus.value = 25
			bonus.message = "A major sequence"
	if five_dice > 0:
		bonus.value = 80
		bonus.message =  "All dice with same value!"
	if four_dice > 0:
		bonus.value = 60
		bonus.message =  "Four of a Kind!"
	if three_dice > 0:
		if pairs == 1:
			bonus.value = 50
			bonus.message =  "Full House!"
		else: 
			bonus.value = 15
			bonus.message =  "Three of a Kind!"
	else:
		if pairs > 1:
			bonus.value = 10
			bonus.message =  "Two pairs!"
		if pairs == 1:
			bonus.value = 5
			bonus.message =  "A pair... meh"
	return(bonus)

func game_over():
	var game_over = game_over_screen.instantiate()
	var count_dice: int = 0
	var dice_array = [0, 0, 0 , 0, 0]
	rollButton.visible = false;
	
	for dice in dice_node_array:
		sum_points(dice.value)
		dice_array[count_dice] = dice.value
		#lock all checkboxes button
		dice.checkBox.disabled = true

	game_over.set_dice_face(dice_array)	
	update_points_label(sum_dice)
	#set data to game over screen
	game_over.dice_points = sum_dice
	game_over.total_points = sum_dice + bonus_value
	game_over.message = bonus_message
	game_over.bonus_points = bonus_value
	game_over.restart_game.connect(_on_restart_game)
	add_child(game_over)

func _on_restart_game():
	get_tree().reload_current_scene()
	
