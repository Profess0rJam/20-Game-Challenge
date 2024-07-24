extends Area2D
signal gameover

func _on_body_entered(body): #emits the hit signal when 2D body enters this area
	if body.name == "Player":
		print("hit")
		gameover.emit()


func _on_visible_on_screen_notifier_2d_screen_exited(): #deletes asteroid when it leaves the screen
	queue_free()
