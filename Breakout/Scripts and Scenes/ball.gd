extends PhysicsBody2D
signal scored
signal brickrestart
var velocity = Vector2(10,450)

func start(pos): #Getting ball position (nobody laugh)
	position = pos
	

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta) #getting data on what it has collided with
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal()) #bouncing off of what we've collided with
		



func _on_detector_body_entered(body): #What does the detector detect?
	if body.is_in_group("bricks"): #If it's a brick, we will do a few things
		print("brick hit") #print brick hit
		scored.emit() #emit a score signal
		brickrestart.emit() #emit the brick restart signal
		body.queue_free() #destroy individual brick
#The score and brick restart signals could probably be cleaned up and fused together, but I'm lazy
