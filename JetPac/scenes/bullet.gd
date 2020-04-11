extends Area2D

const WRAP_MAX = 1070
const WRAP_MIN = -46
const WRAP_DELTA = 1070
const BULLET_SPEED = 1000

var speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(xspeed, bullet_position):
	speed = xspeed * BULLET_SPEED
	position = bullet_position
	# correct for offset and direction
	if xspeed < 0:
		$Sprite.flip_h = true
		position.x -= 8
	else:
		position.x += 48
	$Sprite/AnimationPlayer.play("bullet")

func _physics_process(delta):
	position.x += speed * delta
	# check for wrap
	if position.x >= WRAP_MAX:
		position.x -= WRAP_DELTA
		return
	if position.x <= WRAP_MIN:
		position.x += WRAP_DELTA

func _on_BulletTimer_timeout():
	queue_free()
