extends Control

var total_score = 0
var total_lives = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	incrementScore(0)
	updateLives(0)

func incrementScore(score):
	total_score += score
	$Score.text = "Score: " + str(total_score)

func updateLives(delta):
	total_lives += delta
	$Lives.text = "Lives: " + str(total_lives)
