extends CharacterBody2D

const TERMINAL_VELOCITY = 600
var boost_speed : int = 300
const GRAVITY : int = 400
var game_on : bool = false
signal gameover
func _process(delta):
	var velocity = Vector2(0,0) #Setting player velocity to 0
	if Input.is_action_pressed("move_up") and game_on == true: #If we've pressed the up button...
		velocity.y -= boost_speed #Velocity should change according to boost speed
		$AnimatedSprite2D.play() #play animation while we're in flight
		$jetstream.emitting = true
		
	else:
		velocity.y += GRAVITY
		$AnimatedSprite2D.stop() #stop animation if we aren't flying anymore
		$jetstream.emitting = false
	if velocity.y >= TERMINAL_VELOCITY:
		velocity.y = TERMINAL_VELOCITY
	position += velocity * delta
	move_and_slide()

