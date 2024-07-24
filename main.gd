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
	screen_size = get_window().size
	ground_height = $ground.get_node("Sprite2D").texture.get_height() #grabs the height of the ground
	new_game_setup()
	
func new_game_setup():
	print("new game ready")
	score = 0
	$Player.game_on = false #communicates to the player node that game is not running right now and we shouldn't be boosting up
	get_tree().call_group("asteroids", "queue_free") #clear out any asteroids that might remain from last game
	scroll = 0
	$Player.position = starting_position
	$ScoreTimer.stop() #Stop score timer
	$AsteroidTimer.stop() #Stop asteroid timer
	$HUD/TryAgain.hide() #hide the try again button, we don't need it
	$HUD/StartButton.show()

func _on_hud_start(): #What happens when we hit the start button
	$Player.game_on = true
	scroll = 300
	$ScoreTimer.start()
	$AsteroidTimer.start()
	$Music.play()

func _process(delta):
	if $Player.game_on == true:
		for asteroid in asteroids: #moves asteroids in array
			if not is_instance_valid(asteroid): #if the asteroid isn't on the screen anymore, ignore
				pass
			else: asteroid.position.x -= scroll * delta
			
	if $Player.position.y < 0:
		game_over()



func _on_score_timer_timeout():
	score += 1
	$HUD/ScoreLabel.text = "Score: " + str(score)


func _on_hud_new(): #When we hit the Try Again button it sends us back to the New Game screen
	new_game_setup()

func game_over(): #What happens if we collide with an asteroid
	print("Game Over")
	$Player.game_on = false
	$ScoreTimer.stop()
	$AsteroidTimer.stop()
	$HUD/TryAgain.show() #show the try again button
	$Music.stop()
	if score > high_score:
		high_score = score
		$HUD/HighScoreLabel.text = "High Score: " + str(high_score)



func _on_asteroid_timer_timeout():
	generate_asteroid()
	print("asteroid spawned")
	
func generate_asteroid():
	var asteroid = asteroid_scene.instantiate()
	asteroid.position.x = screen_size.x + ASTEROID_DELAY #Spawns asteroids off screen so they can float in
	asteroid.position.y = (screen_size.y - ground_height) / 2 + randi_range(-asteroid_range, asteroid_range) #take monitor height, subtract ground, divide it by two, add a random range
	asteroid.scale.x = randi_range(1, 2)
	asteroid.scale.y = randi_range (1, 2)
	asteroid.gameover.connect(game_over) #connect gameover signal with game_over function
	add_child(asteroid)
	asteroids.append(asteroid)#Adds asteroid to array so that scroll speed can be applied in delta process
	
