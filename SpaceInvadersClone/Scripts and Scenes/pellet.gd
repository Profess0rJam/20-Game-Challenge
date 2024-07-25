extends Area2D
signal scored
signal bonuspoint
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() #remove pellets once they've left the screen



func _on_body_entered(body):
	if body.is_in_group("invaders"): #Check if we're hitting an invader
		scored.emit() #Emit score signal
		body.queue_free() #if it's an invader, delete it
		queue_free() #delete pellet
	if body.name == "Mothership":
		bonuspoint.emit()
		body.queue_free() # destroy mothership
		print("Mothership hit!")
		queue_free() #delete pellet
		


func _on_area_entered(area):
	if area.name == "EnemyPellet":
		print("enemy pellet hit")
		area.queue_free()
		queue_free()



func _on_area_exited(area):
	if area.name == "EnemyPellet":
		print("exiting enemy pellet")
		area.queue_free()
		queue_free()
