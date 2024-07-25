extends CharacterBody2D


func _ready():
	var invadertype = $AnimatedSprite2D.sprite_frames.get_animation_names() #get a list of animation names from the sprite_frames property. This returns an Array containing their names
	$AnimatedSprite2D.play(invadertype[randi() % invadertype.size()]) #.play plays an animation with the key name (which we got above), then randi() % picks a number between the integers, starting with 0
