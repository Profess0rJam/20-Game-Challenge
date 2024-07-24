extends CharacterBody2D

const GRAVITY : int = 1000 #tells us the gravity
const MAX_VEL : int = 600 #Max fall speed
const FLAP_SPEED : int = -500 #controls how much the flap moves us
var flying: bool = false #will be active as long as the bird is flying 
var falling : bool = false #will activate once the bird hits something
const START_POS = Vector2(100,400) #determines starting position of bird

func _ready():
	reset()

func reset(): #will reset our flags, starting position, and reset any rotation
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)
	
func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta #so long as either condition is true, apply downward momentum
		if velocity.y > MAX_VEL: #terminal velocity, can't go faster than max
			velocity.y = MAX_VEL
	if flying:
		set_rotation(deg_to_rad(velocity.y *0.05)) #deg_to_rad gives us an angle expressed in radians
		#Normally there'd be an animation here, but we'll see if we can get away without one
	elif falling:
		set_rotation(PI/2) #sets rotation to face opposite / downward
	move_and_collide(velocity * delta) #independently moves us downward
		
func flap():
	velocity.y = FLAP_SPEED
	print("Flap!")
