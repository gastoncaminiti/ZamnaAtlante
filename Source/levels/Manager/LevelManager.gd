tool
extends Node

#Declaración de variables de uso interno
var can_change_time = true

#Declaración de variables configurables del nivel
export(bool)   var isNight setget set_night
export(bool)   var toFuture
export(int)    var day
export(float)  var cooldown

var winLevel = false

signal plants_growed
signal plants_decreased
signal plants_stoped

func _ready():
	#Configuración inicial de conexiones con manejadores.
	connect_event_manager("time_changed","_timepass")
	connect_event_manager("future_changed","_goFuture")
	connect_event_manager("past_changed","_goPast")
	connect_event_manager("book_readed","_goRead")
	connect_event_manager("gui_exited","_goExit")
	connect_player_manager("animation_finished","_goAction_after_animation")
	#Configuración inicial de fondo y elementos del HUB
	background_config()
	$HUB.status_gui_zanma(toFuture)
	$HUB.status_gui_sunmoon(isNight)
	$HUB/GUI.notification_day(day)
	$TimerTime.set_wait_time(cooldown)
	winLevel = false

func _timepass():
	if(can_change_time):
		$HUB.transition_gui_sunmoon(isNight)
		if(isNight and toFuture): 
			day+=1				
		if(!isNight and !toFuture):
			day-= 1
		isNight = !isNight
		background_config()
		$HUB/GUI.notification_day(day)
		# Notificación de cambio de tiempo a elementos vivos
		if(toFuture):
			emit_signal("plants_growed")
		else:
			emit_signal("plants_decreased")
		can_change_time= false
		wait()

func _goFuture():
	if(can_change_time && !toFuture):
		toFuture = true
		$HUB.transition_gui_zanma(toFuture)
		can_change_time = false
		wait()

func _goPast():
	if(can_change_time && toFuture):
		toFuture = false
		$HUB.transition_gui_zanma(toFuture)
		can_change_time = false
		wait()
		
func _goRead():
	$Player.AnimPlay("Read")

func _goExit():
	if($HUB/Book.is_visible()):
		$HUB/Book.set_visible(false)

func _on_TimerTime_timeout():
	can_change_time = true
	$HUB.status_gui_sunmoon(isNight)
	emit_signal("plants_stoped")

func wait():
	$TimerTime.start()
	
func hideBook():
	$HUB/Book.set_visible(false)
	
func set_night(new_value):
	isNight = new_value
	if Engine.editor_hint:
		background_config()
		$HUB.status_gui_sunmoon(isNight)

func background_config():
	$Background.material.set("shader_param/back_value", 1 if isNight else 0)

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
	
