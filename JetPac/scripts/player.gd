extends KinematicBody2D

const SPEED = 250
const GRAVITY = 350
const THRUST = 800
const MAX_THRUST = -300
const WRAP_MAX = 1056
const WRAP_MIN = -32
const WRAP_DELTA = 1024

const bullet = preload("res://scenes/bullet.tscn")

signal dropping

var velocity
var can_fire = true
var update_rocket = null

func _ready():
	velocity = Vector2(0, 0)

func getMoveInput(delta):
	velocity.x = 0
	if Input.is_action_pressed("move_left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("move_right"):
		velocity.x += SPEED
	if Input.is_action_pressed("jetpac"):
		# do not thrust if high on the screen
		if position.y > 10:
			velocity.y -= THRUST * delta
			velocity.y = max(velocity.y, MAX_THRUST)
	if velocity.x == 0 and is_on_floor() == true:
		$AnimatedSprite.play("walk")
		$AnimatedSprite.stop()
		$SfxWalking.stop()
	elif is_on_floor() == false:
		$AnimatedSprite.play("fly")
		$SfxWalking.stop()
	else:
		$AnimatedSprite.play("walk")
		# don't restart is already playing
		if $SfxWalking.playing == false:
			$SfxWalking.play()
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
	if not Input.is_action_pressed("fire") or can_fire == false:
		return
	var bullet_direction = 0
	var new_bullet = bullet.instance()
	if $AnimatedSprite.flip_h == false:
		# firing left
		bullet_direction = -1
	else:
		bullet_direction = 1
	new_bullet.init(bullet_direction, position)
	get_parent().add_child(new_bullet)
	# start a timer that blocks firing again
	can_fire = false
	$FireTimer.start()

func _on_FireTimer_timeout():
	can_fire = true

func checkRocketDrop():
	if update_rocket.position.x > 649.5 and update_rocket.position.x < 650.5:
		print("Dropping")
		update_rocket.position.x = 650
		# start the drop
		emit_signal("dropping", update_rocket)
		update_rocket = null

func setRocketPosition():
	update_rocket.position = position
	update_rocket.position.y += 10
	checkRocketDrop()

func setRocket(rocket):
	update_rocket = rocket
	setRocketPosition()

func moveRocket():
	if update_rocket != null:
		setRocketPosition()

func _physics_process(delta):
	checkWrap()
	getMoveInput(delta)
	velocity.y += GRAVITY * delta
	move_and_slide(velocity, Vector2(0, -1))
	if is_on_floor():
		velocity.y = 0.0
	checkFire()
	moveRocket()
