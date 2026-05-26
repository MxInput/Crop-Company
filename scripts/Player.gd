class_name Player
var name
var coins

func buy(price : int):
	if coins >= price:
		coins -= price
		return true
	return false

func sell(price : int):
	coins += price
