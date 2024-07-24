extends CanvasLayer
signal start
signal new

func _on_start_button_pressed():
	start.emit()
	$StartButton.hide()
	print("start button pressed!")



func _on_try_again_pressed():
	new.emit()
