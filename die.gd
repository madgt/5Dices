extends Control

@export var value: int = 0
var locked: bool = false
@onready var label: Label = get_node("VBoxContainer/Label")
@onready var textureRect: TextureRect = $VBoxContainer/diceTexture
@onready var checkBox = $VBoxContainer/CheckButton
var diceTexture: AtlasTexture

#func _draw() -> void:
	#print(locked)

func _ready():
	textureRect.texture = textureRect.texture.duplicate(true)
	diceTexture = textureRect.texture as AtlasTexture

func roll():
	value = randi_range(1,6)
	label.set_text(var_to_str(value))
	set_die_face(value)

func set_die_face(value):
	match value:
		1: diceTexture.region = Rect2(64,0,64,64)
		2: diceTexture.region = Rect2(128,0,64,64)
		3: diceTexture.region = Rect2(64,64,64,64)
		4: diceTexture.region = Rect2(128,64,64,64)
		5: diceTexture.region = Rect2(0,64,64,64)
		6: diceTexture.region = Rect2(0,0,64,64)
	#$AnimatedSprite2D.frame = value - 1
		
func _on_check_button_pressed() -> void:
	locked = !locked
