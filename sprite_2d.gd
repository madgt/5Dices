extends Sprite2D
var speed = 400
var angular_speed = PI

func _ready():
	var timer = get_node("Timer")
	
	print(timer)
	#timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	rotation += angular_speed * delta
	var velocity = Vector2.UP.rotated(rotation) * speed
	position += velocity * delta
	##rotation += angular_speed * delta
	#var direction = 0
	#var velo = Vector2.ZERO
	#
	#if Input.is_action_pressed("ui_left"):
		#direction = -1
	#if Input.is_action_pressed("ui_right"):
		#direction = 1
	#
	#rotation += angular_speed * direction * delta
	#
	#
	#if Input.is_action_pressed("ui_up"):
		#velo = Vector2.UP.rotated(rotation) * speed
	#
	##var velo = Vector2.UP.rotated(rotation) * speed
	#position += velo * delta
	
func _on_timer_timeout():
	visible = not visible

func _on_button_pressed() -> void:
	set_process(not is_processing())
