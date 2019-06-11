tool
extends Node

#Declaración de variables de uso interno
var listPlants
var can_change_time = true

#Declaración de variables configurables del nivel
export(bool)   var isNight setget set_night
export(bool)   var toFuture
export(int)    var day
export(float)  var cooldown

var winLevel = false

signal plants_growed
signal plants_decreased

func _ready():
	#Configuración inicial de conexiones con manejadores.
	connect_event_manager("time_changed","_timepass")
	connect_event_manager("future_changed","_goFuture")
	connect_event_manager("past_changed","_goPast")
	connect_event_manager("book_readed","_goRead")
	connect_event_manager("gui_exited","_goExit")
	connect_player_manager("animation_finished","_goAction_after_animation")
	#Configuración inicial del nivel.
	$Background.material.set("shader_param/back_value", 1 if isNight else 0)
	#Configuración inicial del viaje en el tiempo.
	if(toFuture):
		$HUB/GUI.notificationZanma("Future")
	else:
		$HUB/GUI.notificationZanma("Past")
	#Configuración inicial del numero de días y reconocimiento de nodos vivientes.
	$HUB/GUI.notificationDay(day)
	listPlants = get_tree().get_nodes_in_group("Plants")
	$TimerTime.set_wait_time(cooldown)
	winLevel = false

func _timepass():
	if(can_change_time):
		if(isNight):
			$HUB/GUI.notificationSunMoon("NightToDay")
			$Background.material.set("shader_param/back_value",0)
			if(toFuture):
				day+=1
			isNight = false
		else:
			$HUB/GUI.notificationSunMoon("DayToNight")
			$Background.material.set("shader_param/back_value",1)
			if(!toFuture):
				day-= 1
			isNight = true
		$HUB/GUI.notificationDay(day)
		# Notificación de cambio de tiempo a elementos vivos
		""" for p in listPlants:
			if(toFuture):
				p.grow()
			else:
				p.ingrow()""" 
		if(toFuture):
			emit_signal("plants_growed")
		else:
			emit_signal("plants_decreased")
		can_change_time= false
		wait()

func _goFuture():
	if(can_change_time && !toFuture):
		toFuture = true
		$HUB/GUI.notificationZanma("PastToFuture")
		can_change_time = false
		wait()

func _goPast():
	if(can_change_time && toFuture):
		toFuture = false
		$HUB/GUI.notificationZanma("FutureToPast")
		can_change_time = false
		wait()
		
func _goRead():
	$Player.AnimPlay("Read")

func _goExit():
	if($HUB/Book.is_visible()):
		$HUB/Book.set_visible(false)

func _on_TimerTime_timeout():
	can_change_time = true
	if(isNight):
		$HUB/GUI.notificationSunMoon("Night")
	else:
		$HUB/GUI.notificationSunMoon("Day")
	for p in listPlants:
		p.timeEnd()

func wait():
	$TimerTime.start()
	
func hideBook():
	$HUB/Book.set_visible(false)
	
func set_night(new_value):
	isNight = new_value
	if Engine.editor_hint:
		$Background.material.set("shader_param/back_value", 1 if isNight else 0)
		#Configuración del periodo de tiempo diario.
		if(isNight):
			$HUB/GUI.notificationSunMoon("Night")
		else:
			$HUB/GUI.notificationSunMoon("Day")

# Función que permite conectar una señal del manejador de eventos con una función del manejador de niveles.
func connect_event_manager(nsignal, nfunction):
	if EventManager.connect(nsignal,self,nfunction) != OK:
		print("Error al conectar "+ name +" con el manejador de eventos - Señal "+nsignal+" Función "+nfunction)
		
# Función que permite conectar una señal de estado del jugador con una función del manejador de niveles.
func connect_player_manager(nsignal, nfunction):
	if $Player.connect(nsignal,self,nfunction) != OK:
		print("Error al conectar "+ name +" con el jugador - Señal "+nsignal+" Función "+nfunction)

func _on_Portal_body_entered(body):
	if(body.is_in_group("Players")):
		$Player.AnimPlay("Win")
		winLevel = true

func _goAction_after_animation(status):
	if status == "read":
		$HUB/Book.set_visible(true)
	if status == "win":
		print("Win")
	
