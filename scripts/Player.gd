class_name Player
var coins
var completed_tutorial

func buy(price : int):
	if coins >= price:
		coins -= price
		return true
	return false

func sell(price : int):
	coins += price
