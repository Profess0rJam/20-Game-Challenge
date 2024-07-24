extends CharacterBody2D

const TERMINAL_VELOCITY = 600 #Used to set max speed when not flying
var boost_speed : int = 300 #sets the speed of boost
const GRAVITY : int = 400 #pulls down on player 
var game_on : bool = false #whether the game is running or not. Defined this locally, probably could have handled this in the main script though
func _process(delta):
	var velocity = Vector2(0,0) #Setting player velocity to 0
	if Input.is_action_pressed("move_up") and game_on == true: #If we've pressed the up button...
		velocity.y -= boost_speed #Velocity should change according to boost speed
		$AnimatedSprite2D.play() #play animation while we're in flight
		$jetstream.emitting = true #when we are flying, emit a particle effect
		
	else:
		velocity.y += GRAVITY #velocity adjusts according to gravity constant
		$AnimatedSprite2D.stop() #stop animation if we aren't flying anymore
		$jetstream.emitting = false #if we ain't flyin, no need for particle effects
	if velocity.y >= TERMINAL_VELOCITY: #If we're somehow moving faster than terminal velocity
		velocity.y = TERMINAL_VELOCITY #we're gonna max out at terminal velocity
	position += velocity * delta #update player position every frame according to their velocity
	move_and_slide() #use move_and_slide so that we land on the ground instead of falling through.

