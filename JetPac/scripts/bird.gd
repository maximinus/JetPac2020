extends Area2D

const MIN_YPOS = -32
const WRAP_MAX = 1056
const WRAP_MIN = -32
const WRAP_DELTA = 1024
const MAX_SPEED = 120
const MAX_ANGLE = (30.0 / 360.0) * (2 * PI)
var speed = Vector2(0, 0)

signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func addAngle():
	var angle = randf() * MAX_ANGLE
	speed.y = sin(angle) * MAX_SPEED
	if randf() > 0.5:
		speed.y = -speed.y

func init(ypos):
	# only passed the ypos
	# randomise a speed
	position.y  = ypos
	var xspeed = MAX_SPEED
	if randf() > 0.5:
		xspeed = -MAX_SPEED
	speed = Vector2(xspeed, 0)
	addAngle()
	if xspeed <= 0:
		# right facing
		$AnimatedSprite.flip_h = true
		position.x = 1024
	$AnimatedSprite.play("fly")

func _process(delta):
	# called every frame
	position.x += speed.x * delta
	position.y += speed.y * delta
	# see if they loop around
	if position.x >= WRAP_MAX:
		position.x -= WRAP_DELTA
	elif position.x <= WRAP_MIN:
		position.x += WRAP_DELTA
	# could even go off the top, so check this also
	if position.y < MIN_YPOS:
		# we need to remove the bird from the scene
		killBird(false)

func killBird(animate):
	if animate == true:
		$AnimatedSprite.hide()
		$DeathParticles.emitting = true
		$DeathTimer.start()
	else:
		emit_signal("died")
		queue_free()

func invertBird():
	if speed.y > 0:
		speed.y = -speed.y
	else:
		killBird(true)

func _on_Area2D_body_entered(body):
	# did we hit a floor or a platform?
	if body.is_in_group("platform"):
		killBird(true)
	elif body.is_in_group("floor"):
		invertBird()

func _on_DeathTimer_timeout():
	# Bird is dead, remove from tree and send signal
	killBird(false)
