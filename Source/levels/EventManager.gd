extends Node

var listPlants

func _ready():
	listPlants = get_tree().get_nodes_in_group("Plants")

func _input(event):
	if(event.is_action_pressed("choose_day")):
		for p in listPlants:
			p.grow()
	if (Input.is_action_pressed("choose_night")):
		for p in listPlants:
			p.ingrow()
