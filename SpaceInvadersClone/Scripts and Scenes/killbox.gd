extends Area2D
signal game_over_signal



func _on_body_entered(body):
	if body.is_in_group("invaders"):
		game_over_signal.emit()
		print("Game Over")
