extends KinematicBody2D

const SPEED = 250
const GRAVITY = 300
const THRUST = 700
const MAX_THRUST = -20
const WRAP_MAX = 1056
const WRAP_MIN = -32
const WRAP_DELTA = 1024

var velocity
var can_fire = true

func _ready():
	velocity = Vector2(0, 0)

func getMoveInput(delta):
	velocity.x = 0
	if Input.is_action_pressed("move_left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("move_right"):
		velocity.x += SPEED
	if Input.is_action_pressed("jetpac"):
		velocity.y -= THRUST * delta
		velocity.y = min(velocity.y, MAX_THRUST)
	if velocity.x == 0 and is_on_floor() == true:
		$AnimatedSprite.play("walk")
		$AnimatedSprite.stop()
	elif is_on_floor() == false:
		$AnimatedSprite.play("fly")
	else:
		$AnimatedSprite.play("walk")
	# if not moving, so not change direction
	if velocity.x == 0:
		return
	if velocity.x > 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func checkWrap():
	# if the player has moved too far left or right, wrap the sprite
	if position.x >= WRAP_MAX:
		position.x -= WRAP_DELTA
		return
	if position.x <= WRAP_MIN:
		position.x += WRAP_DELTA

func checkFire():
	if can_fire == false:
		return
	if Input.is_action_pressed("fire"):
		print("Fire!")
	# start a timer that blocks firing again
	can_fire = false
	$FireTimer.start()

func _on_FireTimer_timeout():
	can_fire = true

func _physics_process(delta):
	checkWrap()
	getMoveInput(delta)
	velocity.y += GRAVITY * delta
	move_and_slide(velocity, Vector2(0, -1))
	if is_on_floor():
		velocity.y = 0.0 
	checkFire()
