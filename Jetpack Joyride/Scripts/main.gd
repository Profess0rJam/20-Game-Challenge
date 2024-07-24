extends Node

var scroll : int  #scroll speed of objects
var score : int = 0 #track score of current game
var high_score : int = 0 #track highest score from games in this session
@export var asteroid_scene : PackedScene #allow us to instantiate asteroids
var starting_position = Vector2i(96,601)
var asteroid_range : int = 350 #used for random placement of asteroids
var ASTEROID_DELAY : int = 100 #used to spawn asteroids off screen by 100 pixels so they glide into view
var screen_size : Vector2i #get the dimensions of the screen
var ground_height : int #placeholder for when we grab ground height
var asteroids : Array #obstacles will be stored in this array and then moved as a group later


func _ready():
	screen_size = get_window().size #Get the size of the window
	ground_height = $ground.get_node("Sprite2D").texture.get_height() #grabs the height of the ground
	new_game_setup() #calls the new_game_setup function
	
func new_game_setup(): 
	print("new game ready")
	score = 0 #reset score
	$Player.game_on = false #communicates to the player node that game is not running right now and we shouldn't be boosting up
	get_tree().call_group("asteroids", "queue_free") #clear out any asteroids that might remain from last game
	scroll = 0 #stops scrolling
	$Player.position = starting_position #puts the player in their starting position
	$ScoreTimer.stop() #Stop score timer
	$AsteroidTimer.stop() #Stop asteroid timer
	$HUD/TryAgain.hide() #hide the try again button, we don't need it
	$HUD/StartButton.show() #Shows the Start Button

func _on_hud_start(): #What happens when we hit the start button
	$Player.game_on = true #Switch boolean to true so that the fly input works
	scroll = 300 #asteroids will use this to scroll
	$ScoreTimer.start() #Score timer starts
	$AsteroidTimer.start() #Asteroid spawning timer starts 
	$Music.play() #The song "Ron Paul" by yoloswag studios will loop until the player gets a game over

func _process(delta): #Every frame, the following things will happen
	if $Player.game_on == true: #Check if the game is on
		for asteroid in asteroids: #moves asteroids in array
			if not is_instance_valid(asteroid): #if the asteroid isn't on the screen anymore (and therefore deleted), ignore
				pass
			else: asteroid.position.x -= scroll * delta #repositions asteroids
			
	if $Player.position.y < 0: #If the player has gone past the y boundary at the top of the screen, give them a game over
		game_over()



func _on_score_timer_timeout(): #Score timer only goes for one second
	score += 1 #Each second that goes by, increase score by one
	$HUD/ScoreLabel.text = "Score: " + str(score) #Update ScoreLabel with new score


func _on_hud_new(): #When we hit the Try Again button it sends us back to the New Game screen
	new_game_setup()

func game_over(): #What happens if we collide with an asteroid
	$Player.game_on = false #False condition for game_on stops us from flying
	$ScoreTimer.stop() #No more points for losers
	$AsteroidTimer.stop() #No more asteroids for losers
	$HUD/TryAgain.show() #show the try again button
	$Music.stop() #No more music for losers
	if score > high_score: #If your new score is higher than your high score
		high_score = score #It is now your new high score
		$HUD/HighScoreLabel.text = "High Score: " + str(high_score) #Update high score display



func _on_asteroid_timer_timeout(): #The asteroid timer is also like, one second
	generate_asteroid() #call function to create asteroids
	
func generate_asteroid(): #
	var asteroid = asteroid_scene.instantiate() #store scene in variable
	asteroid.position.x = screen_size.x + ASTEROID_DELAY #Spawns asteroids off screen so they can float in, instead of popping in 
	asteroid.position.y = (screen_size.y - ground_height) / 2 + randi_range(-asteroid_range, asteroid_range) #take monitor height, subtract ground, divide it by two, add a random range
	asteroid.scale.x = randi_range(1, 2) #Add randomization to asteroid width
	asteroid.scale.y = randi_range (1, 2) #Add randomization to asteroid height
	asteroid.gameover.connect(game_over) #connect gameover signal with game_over function
	add_child(asteroid) #actually spawn in asteroid as child node
	asteroids.append(asteroid)#Adds asteroid to array so that scroll speed can be applied in delta process
	
