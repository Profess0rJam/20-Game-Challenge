extends Area2D
signal shot


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() #remove pellets once they've left the screen


func _on_body_entered(body):
	if body.name == "Player": #Check if we're hitting an invader
		shot.emit()
		print("Player hit!")
		queue_free()



func _on_area_entered(area):
	if area.name == "pellet":
		free()



func _on_area_exited(area):
	if area.name == "pellet":
		free()
