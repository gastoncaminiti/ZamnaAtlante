extends Node

var movements

func reset_movements():
	movements = 0

func add_movements():
	movements +=1

func get_movements():
	return movements