extends Node

var listPlants
export(bool) var isNight
export(bool) var toFuture

func _ready():
	listPlants = get_tree().get_nodes_in_group("Plants")

func timepass():
	if(isNight):
		isNight = false
		$GUI/SunMoonContainer/SunMoon/AnimationPlayer.play("DayToNight")
	else:
		isNight = true
		$GUI/SunMoonContainer/SunMoon/AnimationPlayer.play("NightToDay")
	
	for p in listPlants:
		if(toFuture):
			p.grow()
		else:
			p.ingrow()

func goFuture():
	toFuture = true
	$GUI/ZamnaContainer/HBoxContainer/Zamna/AnimationPlayer.play("PastToFuture")
func goPass():
	toFuture = false
	$GUI/ZamnaContainer/HBoxContainer/Zamna/AnimationPlayer.play("FutureToPast")