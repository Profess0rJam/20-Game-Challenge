extends Area2D

signal hit
signal scored

func _on_body_entered(body):
	print("You've hit a pipe")
	hit.emit()


func _on_score_area_body_entered(body):
	scored.emit()
	print("You score a point")
