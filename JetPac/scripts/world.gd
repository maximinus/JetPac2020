extends Node2D

const MAX_ENEMIES = 25
const MIN_ENEMIES = 8
# this is as a %/100 per frame, so it needs to be low
const NEW_ENEMY_CHANCE = 0.01
const YSTART_MIN = 64
const YSTART_MAX = 696
const DROP_ROCKETS_SPEED = 100

const BIRD = preload("res://scenes/bird.tscn")
const cn = preload("res://scripts/constants.gd")

var enemies = 0
var expected_rocket = cn.PART.BOTTOM
var dropping_rocket = null

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	# connect rocket signals
	$RocketBottom.connect("pickup", self, "pickupRocket")
	$RocketMiddle.connect("pickup", self, "pickupRocket")
	$RocketTop.connect("pickup", self, "pickupRocket")
	$Player.connect("dropping", self, "dropRocket")

func pickupRocket(rocket):
	# if currently dropping, do not pick up the rocket
	if dropping_rocket != null:
		return
	if expected_rocket != rocket.rocket_part:
		return
	if $Player.update_rocket != null:
		# already carrying, so ignore this signal
		return
	# pickup the rocket
	$Player.setRocket(rocket)

func dropRocket(rocket):
	# we should now drop the next piece of rocket
	rocket.position.x = 650
	dropping_rocket = rocket
	expected_rocket = helpers.nextRocketPart(expected_rocket)

func enemyDied():
	if enemies > 0:
		enemies -= 1

func incrementScore(score):
	$Control.incrementScore(score)

func createNewEnemy():
	# get the starting y position
	var starty = (YSTART_MAX - YSTART_MIN) * randf()
	starty += YSTART_MIN
	# create the new enemy
	var new_enemy = BIRD.instance()
	new_enemy.init(starty)
	# connect the signal
	new_enemy.connect("died", self, "enemyDied")
	new_enemy.connect("score", self, "incrementScore")
	# add the new entity
	add_child(new_enemy)
	enemies += 1

func checkForNewEnemy():
	if enemies < MIN_ENEMIES:
		createNewEnemy()
		return
	if randf() <= NEW_ENEMY_CHANCE:
		createNewEnemy()

func rocketReady():
	# we are done with the rocket
	print("Rocket is ready!")
	print($RocketTop.position)
	print($RocketMiddle.position)
	print($RocketBottom.position)

func dropAllRockets(delta):
	if dropping_rocket == null:
		# no work to do
		return
	var finished = false
	dropping_rocket.position.y += DROP_ROCKETS_SPEED * delta
	var drop_pos = helpers.getRocketDropHeight(dropping_rocket.rocket_part)
	if dropping_rocket.position.y > drop_pos:
		dropping_rocket.position.y = drop_pos
		# if the top has finished dropping, then the rocket is ready
		# handle this later, after cleanup
		if dropping_rocket.rocket_part == cn.PART.TOP:
			finished = true
		dropping_rocket = null
	if finished == true:
		rocketReady()

func _process(delta):
	if enemies < MAX_ENEMIES:
		checkForNewEnemy()
	dropAllRockets(delta)
