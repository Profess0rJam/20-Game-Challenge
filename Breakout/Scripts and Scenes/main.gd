extends Node
var score : int = 0
var lives : int = 3
var restartcount : int = 0
@export var brick_scene: PackedScene #Unsure if I actually need this, stores individual brick scene
@export var instabricks: PackedScene #Stores the bricks-as-rows scene
# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD/RestartButton.hide() #hide restart button since we don't need it right away
	new_game() #calls new game function
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	
	var newbricks = instabricks.instantiate() #make sure we can load the bricks in at the start
	lives = 3 #give the player three lives
	score = 0 #set score to zero
	$Paddle.start($PaddleStart.position) #get paddle in the correct position
	$HUD.update_score(score) #update score label to 0
	$HUD.update_lives(lives) #update lives to 3
	get_tree().call_group("bricks", "queue_free") #delete any leftover bricks from last game
	add_child(newbricks) #instantiate rows of bricks
	await get_tree().create_timer(1.0).timeout #give player a second to prepare
	$Ball.start($BallStart.position) #Put the ball in the start position
	
	
	
func new_round(): #fired whenever the ball goes into the killzone
	$Paddle.start($PaddleStart.position) #get paddle in correct position
	$HUD.message_new_round() #Displays the "get ready" message
	await get_tree().create_timer(1.0).timeout #give player a second to register what's happening
	$Ball.start($BallStart.position) #Put the ball in the start position





func game_over():
	$HUD.show_game_over() #Show game over message
	$HUD/RestartButton.show() #reveal Restart Button


func _on_kill_area_dead(): #Triggers every time ball enters the "kill zone" at the bottom
	if lives > 1: #Check if we have more than one life
		lives -= 1 #If we have more than one life, subtract it
		$HUD.message_new_round() #warns player that they have another life!
		new_round()
	else:
		lives = 0 #if they were at one life or less (somehow) set them to zero
		game_over() #Give them the ole game over
	$HUD.update_lives(lives) #update life counter



func _on_ball_scored(): #Triggered whenever the ball hits a brick
	score += 1 #update score value by one
	$HUD/ScoreLabel.text = "Score: " + str(score) #update score label by converting score int into a string
	$ScoreNoise.play() #HOLY MOLY
	


func _on_ball_brickrestart(): #Also triggered each time the ball hits a brick... could just combine the two functions?
	var newbricks = instabricks.instantiate() #double extra special super duper make sure the bricks can be instantiated again
	restartcount += 1 #tick up the restart counter
	if restartcount >= 20: #if it's 20....
		$HUD.new_round_begin() #tell player new round is starting
		restartcount = 0 #reset the count
		lives += 1 #award the player with a life
		get_tree().call_group("bricks", "queue_free") #clear out any rogue bricks that somehow escaped destruction
		add_child(newbricks) #spawn in new rows of bricks
		$Paddle.start($PaddleStart.position) #get paddle in the correct position
		await get_tree().create_timer(1.0).timeout #give player a second to register what's happening
		$Ball.start($BallStart.position) #Put the ball in the start position
