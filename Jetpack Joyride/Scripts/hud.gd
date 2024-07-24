extends CanvasLayer
signal start #Signal that will actually help start the game
signal new #Signal that will bring us to the "Start Game" button

func _on_start_button_pressed():
	start.emit()
	$StartButton.hide()#Once we press the button, we want to hide it



func _on_try_again_pressed():
	new.emit()
