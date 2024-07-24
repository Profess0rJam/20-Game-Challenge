extends Area2D
signal gameover #signal will be used in main script to give a game over

func _on_body_entered(body): #emits the hit signal when 2D body enters this area
	if body.name == "Player": #make sure we're only sending this signal when it's the player colliding, since asteroids collide frequently
		gameover.emit() #Emit the game over signal (used in main script)


func _on_visible_on_screen_notifier_2d_screen_exited(): #deletes asteroid when it leaves the screen
	queue_free()
