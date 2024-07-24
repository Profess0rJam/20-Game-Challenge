extends CanvasLayer
signal start_game

# Called when the node enters the scene tree for the first time.
func show_message(text):
	$Message.text = text #will let us change the message text in the main scene

func message_new_round():
	show_message("Life lost! Try again!")

func show_game_over():
	show_message("Game Over!")

func update_score(score):
	$ScoreLabel.text = "Score: " + str(score)
	
func update_lives(lives):
	$LivesLabel.text = "Lives: " + str(lives)
	
func new_round_begin():
	show_message("New Round!")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func restart_button_pressed():
	$RestartButton.hide()
	start_game.emit()
