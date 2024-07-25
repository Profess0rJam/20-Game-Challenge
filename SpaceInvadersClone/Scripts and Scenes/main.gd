extends Node
@export var pellet_scene : PackedScene #allow us to access pellet scene
@export var invader_wave : PackedScene #allows us to access invader_wave scene
@export var enemypellet_scene : PackedScene #allows us to access enemy_pellet scene
@export var mothership_scene : PackedScene #allows us to access mothership scene
var player_pellets : Array #stores player pellets to allow us to move them
var invader_array : Array #Store invaders in an array, used to randomly decide who will shoot at player
var enemy_pellet_array: Array #Store enemy pellets so we can move them as a group
var mothership_array: Array #store motherships so they can be moved in delta
var game_on : bool = false #Default set to false so that the game doesn't start unexpectedly
var pellet_speed : int = -4 #Determines the speed of pellets
var score : int #Tracks score for current play session
var reset_count : int = 0 #There are 60 invaders, so when this reaches 60, it means they've been wiped out and need a new round to start
var invaders_go_left : bool = false #Used to dictate invader movement
var invader_movement : int #Used to track invader movement. 
var invaderhorizontalscroll = 9 #determines how many pixels the invaders will move upon horizontal timer timeout
var invaderverticalscroll = 30 #determines number of pixels that the invaders will move upton vertical timer timeout
var highscore : int = 0 #keeps track of high score
var lives : int #Keeps track of how many lives we have
var can_shoot : bool = true #checks if player can shoot again

func _ready():
	new_game() #Set up a fresh new game when the game launches


func new_game():
	$Player.position = Vector2(300,945) #Set starting position
	score = 0 #reset score
	lives = 3 #reset lives
	$HUD/ScoreLabel.text = "Score: " + str(score) #update score label
	$HUD/LivesLabel.text = "Lives: " + str(lives) #Update lives label
	var newwave = invader_wave.instantiate() #make sure we can instantiate fresh wave
	get_tree().call_group("invaders", "queue_free") #delete any old invaders
	get_tree().call_group("pellets", "queue_free") #despawn old pellets
	invader_array.clear() #clear out old invaders
	add_child(newwave) #Spawn in rows of invaders
	for invader in $InvaderWave.get_children(): #for each invader in the wave
		invader_array.append(invader) #append it to the array
		print("Invader added to array") #print so I know it's working
	invader_movement = 0 #integer used for tracking invader movement direction is reset
	reset_count = 0 #integer used to keep track of when to start a new wave is reset
	var shooter = invader_array[randi() % invader_array.size()]
	$"HUD/Try Again?".hide() #hide the Try Again button
	$HUD/StartNewWave.hide() #Hide the Start New Wave button
	$HUD/StartButton.show() #Show the start game button
	$HorizontalTimer.stop() #Make sure movement timers are stopped
	$VerticalTimer.stop() #Make sure movement timers are stopped
	$MothershipTimer.stop() #Make sure we aren't spawning motherships
	$PlayerShootTimer.stop() #Make sure player shoot timer is stopped

func new_round():
	game_on = true #Turns the game on. This allows for shooting from the player
	$Player.position = Vector2(300,945) #Set starting position
	invaders_go_left = false #Make sure invaders don't go off screen
	var newwave = invader_wave.instantiate() #make sure we can instantiate fresh wave
	get_tree().call_group("invaders", "queue_free") #delete any old invaders
	invader_array.clear() #clear out old invaders
	add_child(newwave) #Spawn in rows of invaders
	for invader in $InvaderWave.get_children(): #for each invader in the wave
		invader_array.append(invader) #append it to the array
		print("Invader added to array") #print so I know it's working
	reset_count = 0 #Set this back to 0, requiring the player to destroy all invaders to go to the next round
	$HorizontalTimer.start() #Start horizontal timer for invader movement
	$VerticalTimer.start() #Start vertical timer for invader movement
	$ShootTimer.start() #Starts timer for invaders to randomly shoot
	$PlayerShootTimer.start() #Begin timer that will regular player rate of fire
	$MothershipTimer.start() #countdown to spawning motherships
	
func new_round_setup(): #What happens when the reset count reaches 60 (a cleared wave)
	game_on = false #Stop player shooting 
	$HorizontalTimer.stop() #Stop timer for invader horizontal movement
	$VerticalTimer.stop() #Stop timer for invader vertical movement
	$PlayerShootTimer.stop()#Stop timer that regulates player rate of fire
	$MothershipTimer.stop() #Make sure we aren't spawning motherships
	var newwave = invader_wave.instantiate() #make sure we can instantiate fresh wave
	get_tree().call_group("invaders", "queue_free") #delete any old invaders
	get_tree().call_group("pellets", "queue_free") #despawn old pellets
	add_child(newwave) #Spawn in rows of invaders
	invader_movement = 0 #Reset integer that signals when invaders should switch from left or right movement
	$HUD/StartNewWave.show() #Show the New Wave button, give players a breather before starting
	if score > highscore: #Check if score is higher than high score
		$HUD/HighScoreLabel.text = "High Score: " + str(score) #Update high score between rounds to give sense of accomplishment
		
func game_over():
	game_on = false #Turn off shooting
	$HorizontalTimer.stop() #Stop horizontal movement of invaders
	$VerticalTimer.stop() #Stop vertical movement of invaders
	$ShootTimer.stop() #Stop timing for invaders to shoot
	$MothershipTimer.stop() #Stop timing for mothership spawns
	$"HUD/Try Again?".show() #Show the Try Again button
	if score > highscore: #Check if score is higher than high score
		$HUD/HighScoreLabel.text = "High Score: " + str(score) #Update High Score Label with new high score
	get_tree().call_group("pellets", "queue_free") #Despawn old pellets


func _process(delta):
	if game_on == true: #If the game is running 
		if can_shoot == true:
			if Input.is_action_just_pressed("shoot"): #Spacebar, "w", or up arrow will count as "shoot"
				can_shoot = false
				var pellet = pellet_scene.instantiate() #Allow us to instantiate more pellets
				pellet.position.y = $Player.position.y - 33 #have the pellet spawn in front of player a bit
				pellet.position.x = $Player.position.x #Have the pellet have the same x coords as the player
				pellet.scored.connect(_on_pellet_scored) #Connect the pellet to the score signal
				pellet.bonuspoint.connect(_on_pellet_bonuspoint)#Connect the pellet to the bonus point signal
				add_child(pellet) #Spawn pellet in
				player_pellets.append(pellet) #Add pellet to Array of pellets
		for pellet in player_pellets: #For each pellet in the array
			if not is_instance_valid(pellet): #If it isn't on screen, don't bother
				pass
			else: 
				pellet.position.y += pellet_speed #All on screen pellets will move on the y axis according to pellet speed
		for enemypellet in enemy_pellet_array:
			if not is_instance_valid(enemypellet):
				pass
			else:
				enemypellet.position.y -= pellet_speed
		for mothership in mothership_array:
			if not is_instance_valid(mothership):
				pass
			else:
				mothership.position.x -= pellet_speed + 3

func _on_pellet_scored(): #When the scored signal is emitted
	score += 1 #Score goes up by one
	reset_count +=1 #Reset count also goes up by one
	$HUD/ScoreLabel.text = "Score: " + str(score) #Update Score display
	if reset_count >= 60: #There are 60 invaders in a wave, so upon reaching 60 count, it stands to reason that the wave is over
		reset_count = 0 #Set the count back to 0
		$HorizontalTimer.stop() #Stop movement of invaders
		$VerticalTimer.stop() #Stop movement of invaders
		get_tree().call_group("pellets", "queue_free")
		new_round_setup() #Run new_round_setup
		


func _on_horizontal_timer_timeout(): #Handles movement of invader wave
	if invaders_go_left == true: #Check to see if we're moving left or right
		call_deferred("invadeleft")

	elif invaders_go_left == false: #Check to see if we're moving left or right
		call_deferred("invaderight")

func invadeleft():
	$InvaderWave.position.x -= invaderhorizontalscroll #have invaders move over according to invader scroll
	invader_movement += 1 #tick the invader movement count up by one
	if invader_movement >= 10: #If we've reached three ticks, we need to switch directions
		invader_movement = 0 #Reset invader movement
		invaders_go_left = false #Signal that we are not going left anymore
		
func invaderight():
	$InvaderWave.position.x += invaderhorizontalscroll #have invaders move over according to invader scroll
	invader_movement += 1 #tick the invader movement count up by one
	if invader_movement >= 10:  #If we've reached three ticks, we need to switch directions
		invader_movement = 0 #Reset invader movement
		invaders_go_left = true #Signal that we are not going left anymore

func _on_vertical_timer_timeout():
	$InvaderWave.position.y +=  invaderverticalscroll #On timer timeout, invaders move towards the bottom of the screen

func _on_killbox_game_over_signal(): #If the invaders touch the killbox at the bottom of the screen, it's game over
	game_over()

func _on_start_button_pressed(): #When we press the start button
	new_round() #Run the new_round function
	$HUD/StartButton.hide() #hide the Start Button

func _on_try_again_pressed(): #When we press the try again button after a game over
	new_game() #Run the new_game function
	$"HUD/Try Again?".hide() #Hide the Try Again button

func _on_start_new_wave_pressed(): #When we've clicked the "Start New Wave" button
	new_round() #Start a new wave
	$HUD/StartNewWave.hide() #hide the Start New Wave button

func _on_shoot_timer_timeout():
	var shooter = invader_array[randi() % invader_array.size()] #picks a shooter from the invaders in the array
	var enemypellet = enemypellet_scene.instantiate() #makes a pellet from the packed scene
	if not is_instance_valid(shooter): #Check to see if the shooter is actually there
		pass
	else:
		enemypellet.position.y = shooter.global_position.y #Pellet should line up with the invader it's shot from
		enemypellet.position.x = shooter.global_position.x #Pellet should line up with the invader it's shot from
		add_child(enemypellet) #spawn in the pellet
		enemypellet.shot.connect(_on_enemy_pellet_shot) #Connect it with the shot signal
		enemy_pellet_array.append(enemypellet) #add to enemy pellet array so pellets can be moved together
	
func _on_enemy_pellet_shot():
	lives -= 1 #Player loses life if shot
	$HUD/LivesLabel.text = "Lives: " + str(lives) #Update score label with new count
	if lives <= 0: #If you're out of lives, you're done
		game_over() #run game over function


func _on_player_shoot_timer_timeout():
	can_shoot = true #Allows player to shoot again

func _on_mothership_timer_timeout(): #When the mothership timer finishes
	var mothership = mothership_scene.instantiate() #Access mothership scene
	mothership.position.y = 60 #Place it high up on the screen
	mothership.position.x = -10 #place it slightly off to the left off screen so it drifts into view
	add_child(mothership)
	mothership_array.append(mothership)

func _on_pellet_bonuspoint():
	score += 30 #HUUUGE POINTS
	$HUD/ScoreLabel.text = "Score: " + str(score) #Update Score display
