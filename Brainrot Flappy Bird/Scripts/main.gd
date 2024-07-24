extends Node
var game_running : bool #Is the game running, yes or no?
var game_over : bool #Is the game over, yes or no?
var scroll : int #variable used to scroll images across the screen
var score #variable to keep track of score
const SCROLL_SPEED : int = 4 #speed of the scroll
var screen_size : Vector2i #placeholder for now
var ground_height : int #placeholder for now
var pipes : Array #Holds the pipes we create
const PIPE_DELAY : int = 100 #Pipe generation variable- gives a delay so pipes don't just pop into place
const PIPE_RANGE: int = 200 #Pipe generation variable- used to add some randomness to pipe configuration
@export var pipe_scene : PackedScene #This allows us to access the pipe scene, remember to load this in the inspector
var high_score : int = 0


func _ready(): #Will just fire our new game function
	screen_size = get_window().size #get the size of the screen. This is important to the scrolling!
	ground_height = $Ground.get_node("Sprite2D").texture.get_height() #get the height of the ground
	new_game()

func new_game(): #resetting our starting variables
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$Bird/CollisionShape2D.set_deferred("disabled",false)
	$GameOver.hide()
	get_tree().call_group("pipes", "queue_free")
	$ScoreLabel.text = "SCORE: " + str(score)
	pipes.clear() #clears out our pipe array for accurate score keeping
	generate_pipes() #get a set of pipes before the game autogenerates the rest
	$Bird.reset() #calls Bird's reset function -> check bird script


func _input(event):
	if game_over == false: #if the game isn't over
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed: #Check to see if left mouse button has been pressed (could just Input Map this?)
				if game_running == false: 
					start_game() #if the game wasn't running yet when we click, start the game
				else:
					if $Bird.flying:
						$Bird.flap() #don't forget the parantheses you clown! That cost you like twenty minutes!
						check_top() #each time we flap, we check if we've reached the top of the screen, resulting in a game over
					
func start_game():
	game_running = true #switches game_running boolean to true
	$Bird.flying = true #setting bird flying tag to true gives it gravity, check physics process in Bird script
	$Bird.flap #Flap once
	$PipeTimer.start()
	$Music.play()
	check_top()
	
func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED #this assigns scroll the value of scroll speed
		if scroll >= screen_size.x: #if scroll value becomes larger than the screensize we've stored, reset the scroll progress
			scroll = 0
		$Ground.position.x = -scroll #every single frame, the image's position will be moved according to the scroll value that has been added up
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED #actually moves the pipes by adding scroll speed to their x axis every frame


func _on_pipe_timer_timeout():
	generate_pipes() #every time the timer runs out, generate some peters

func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY #Pipe delay gives some extra time, so that it doesn't just pop out of thin air on screen.
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE) #looks at screen height, subtracts ground height, divides by two (since we have two pipes) and then adds a random number from pipe range
	pipe.hit.connect(bird_hit) #connect to the hit signal the pipes emit
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe) #adds pipes to the array we created earlier, which will help us get our score

func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score) #gets score value, turns it into string to display on label
	

func check_top():
	if $Bird.position.y < 0: #If the bird's y coordinate is less than 0, that means it's off the screen.
		$Bird.falling = true
		stop_game()
	
func stop_game(): #stops peter from spawning, stops flying, ends game, makes it a game over
	$PipeTimer.stop()
	$Bird.flying = false
	game_running = false
	game_over = true
	$Bird/CollisionShape2D.set_deferred("disabled",true)
	$GameOver.show()
	$Music.stop()
	$GameOverSound.play()
	if score >= high_score:
		high_score = score
		$HighScore.text = "HIGH SCORE: " +str(high_score) 
	

func bird_hit():
	$Bird.falling = true
	stop_game()


func _on_ground_hit():
	$Bird.falling = false
	stop_game()


func _on_game_over_restart():
	new_game()
