extends CharacterBody2D

var speed : int = 200
var screen_size
func _ready():
	screen_size = get_viewport_rect().size #get the size of the screen
	
func _process(delta):
	var velocity = Vector2(0,0) #Define velocity as Vector2, set it to 0
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	position += velocity * delta
	position = position.clamp(Vector2(0,0), screen_size)
