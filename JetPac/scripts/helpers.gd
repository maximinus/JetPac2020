extends Node

const cn = preload("res://scripts/constants.gd")

func nextRocketPart(part):
	if part == cn.PART.BOTTOM:
		return cn.PART.MIDDLE
	if part == cn.PART.MIDDLE:
		return cn.PART.TOP
	return cn.PART.END

func getRocketDropHeight(part):
	# return the y position of this dropping rocket
	if part == cn.PART.BOTTOM:
		return 704
	if part == cn.PART.MIDDLE:
		return 640
	if part == cn.PART.TOP:
		return 576
	# in case of error
	return 0
