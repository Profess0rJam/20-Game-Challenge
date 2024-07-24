extends Area2D
signal dead



func _on_body_entered(body):
	print("Out of bounds!")
	await get_tree().create_timer(1.0).timeout #creates a one-shot timer and waits for it to finish
	dead.emit()
