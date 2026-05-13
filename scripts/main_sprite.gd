extends CharacterBody2D

const SOUND_WALK:= preload("res://Sounds/wova-zvuki-shagi-beg-po-betonnomu-polu (mp3cut.net) (2).mp3")
const SOUND_JUMP:= preload("res://Sounds/c3a799694397ac6.mp3")

const SPEED = 350.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	if (velocity.x >1 || velocity.x <-1):
		sprite_2d.animation = "running"
	else:
			sprite_2d.animation = "default"
			
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite_2d.animation="jumping"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$movesound.stream = SOUND_JUMP
		$movesound.pitch_scale = 1.0
		$movesound.play()
		$movesound/Timer.start()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if $movesound/Timer.time_left==0 and is_on_floor():
			$movesound.stream = SOUND_WALK
			$movesound.pitch_scale = 1.0 + randf_range(-0.1 , 0.1)
			$movesound.play()
			$movesound/Timer.start()
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 17)

	move_and_slide()
	 
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft 
