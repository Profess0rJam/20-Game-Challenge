extends Area2D

signal hit

func _on_body_entered(body):
	print("You hit the ground")
	hit.emit()
