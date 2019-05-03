extends Node

#Declaración de variables de uso interno
var listPlants
var can_change_time = true

#Declaración de variables configurables del Nivel
export(bool)   var isNight
export(bool)   var toFuture
export(int)    var day
export(float)  var cooldown


func _ready():
	if(isNight):
		$Background.material.set("shader_param/back_value",1)
		$GUI.notificationSunMoon("Night")
	else:
		$Background.material.set("shader_param/back_value",0)
		$GUI.notificationSunMoon("Day")
	$GUI.notificationDay(day)
	listPlants = get_tree().get_nodes_in_group("Plants")
	$TimerTime.set_wait_time(cooldown)

func timepass():
	if(can_change_time):
		if(isNight):
			$GUI.notificationSunMoon("NightToDay")
			$Background.material.set("shader_param/back_value",0)
			if(toFuture):
				day+=1
			isNight = false
		else:
			$GUI.notificationSunMoon("DayToNight")
			$Background.material.set("shader_param/back_value",1)
			if(!toFuture):
				day-= 1
			isNight = true
		$GUI.notificationDay(day)
		# Notificación de cambio de tiempo a elementos vivos
		for p in listPlants:
			if(toFuture):
				p.grow()
			else:
				p.ingrow()
		can_change_time= false
		wait()

func goFuture():
	if(can_change_time && !toFuture):
		toFuture = true
		$GUI.notificationZanma("PastToFuture")
		can_change_time = false
		wait()

func goPass():
	if(can_change_time && toFuture):
		toFuture = false
		$GUI.notificationZanma("FutureToPast")
		can_change_time = false
		wait()

func wait():
	$TimerTime.start()

func _on_TimerTime_timeout():
	can_change_time = true
	if(isNight):
		$GUI.notificationSunMoon("Night")
	else:
		$GUI.notificationSunMoon("Day")
	for p in listPlants:
		p.timeEnd()

func _on_Portal_body_entered(body):
	if(body.is_in_group("Players")):
		$Player.AnimPlay("Win")

