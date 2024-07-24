extends StaticBody2D
@export var speed = 800
var screen_size #Size of game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size #get the size of the screen

func start(pos):
	position = pos #get position of the paddle
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2(0,0) #Don't have momentum carry between frames, duh
	if Input.is_action_pressed("move_left"): #To the left!
		velocity.x -= 1
	if Input.is_action_pressed("move_right"): #To the right!
		velocity.x += 1
	if velocity.length() > 0: #Take it back now y'all! Just kidding, we're normalizing velocity
		velocity = velocity.normalized() * speed #normalize velocity and then multiply by speed variable
	position += velocity * delta #actually change position of paddle
	position = position.clamp(Vector2(0,0), screen_size) #make sure we can't go off screen

