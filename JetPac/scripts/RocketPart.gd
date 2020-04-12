extends Area2D

var top_gfx = preload("res://gfx/rocket_top.png")
var mid_gfx = preload("res://gfx/rocket_middle.png")
var bot_gfx = preload("res://gfx/rocket_bottom.png")

const cn = preload("res://scripts/constants.gd")
export (cn.PART) var rocket_part

signal pickup

func _ready():
	setRocketPart(rocket_part)

func setRocketPart(new_part):
	if new_part == cn.PART.TOP:
		$Sprite.texture = top_gfx
	elif new_part == cn.PART.MIDDLE:
		$Sprite.texture = mid_gfx
	else:
		$Sprite.texture = bot_gfx

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("pickup", self)
