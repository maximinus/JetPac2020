extends Node2D

const MAX_ENEMIES = 30
const MIN_ENEMIES = 10
# this is as a %/100 per frame, so it needs to be low
const NEW_ENEMY_CHANCE = 0.01
const YSTART_MIN = 64
const YSTART_MAX = 696

const BIRD = preload("res://scenes/bird.tscn")

var enemies = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func enemyDied():
	if enemies > 0:
		enemies -= 1

func createNewEnemy():
	# get the starting y position
	var starty = (YSTART_MAX - YSTART_MIN) * randf()
	starty += YSTART_MIN
	# create the new enemy
	var new_enemy = BIRD.instance()
	new_enemy.init(starty)
	# connect the signal
	new_enemy.connect("died", self, "enemyDied")
	# add the new entity
	add_child(new_enemy)
	enemies += 1

func checkForNewEnemy():
	if enemies < MIN_ENEMIES:
		createNewEnemy()
		return
	if randf() <= NEW_ENEMY_CHANCE:
		createNewEnemy()

func _process(delta):
	if enemies < MAX_ENEMIES:
		checkForNewEnemy()
