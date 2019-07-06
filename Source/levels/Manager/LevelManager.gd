extends Node

#Declaración de variables de uso interno
var can_change_time = true
var COOLDOWN = 1
#Declaración de variables configurables del nivel
export(bool)   var isNight setget set_night
export(bool)   var toFuture
export(int)    var day

signal plants_growed
signal plants_decreased
signal plants_stoped

func _ready():
	set_block_level(false)
	DataManager.reset_movements()
	#Configuración inicial de conexiones con manejadores.
	connect_event_manager("time_changed","_timepass")
	connect_event_manager("future_changed","_goFuture")
	connect_event_manager("past_changed","_goPast")
	connect_event_manager("book_readed","_goRead")
	connect_event_manager("gui_exited","_goExit")
	connect_player_manager("animation_finished","_goAction_after_animation")
	#Configuración inicial de fondo y elementos de la interfaz
	background_config()
	$HUB.status_gui_zanma(toFuture)
	$HUB.status_gui_sunmoon(isNight)
	$HUB.set_gui_day(day)
	$HUB.set_open_book(false)
	$TimerTime.set_wait_time(COOLDOWN)
	$SoundLevelManager.play_sound("game")
	
func _timepass():
	if(can_change_time):
		$HUB.transition_gui_sunmoon(isNight)
		DataManager.add_movements()
		if(isNight and toFuture): 
			day+=1
		if(!isNight and !toFuture):
			day-= 1
		isNight = !isNight
		background_config()
		$SoundLevelManager.play_sound("night" if isNight else "day")
		$HUB.set_gui_day(day)
		# Notificación de cambio de tiempo a elementos vivos
		if(toFuture):
			emit_signal("plants_growed")
		else:
			emit_signal("plants_decreased")
		can_change_time= false
		wait()

func _goFuture():
	if(can_change_time && !toFuture):
		DataManager.add_movements()
		toFuture = true
		$HUB.transition_gui_zanma(toFuture)
		can_change_time = false
		wait()

func _goPast():
	if(can_change_time && toFuture):
		DataManager.add_movements()
		toFuture = false
		$HUB.transition_gui_zanma(toFuture)
		can_change_time = false
		wait()
		
func _goRead():
	if($HUB.is_open_book()):
		$Player.AnimPlay("Read")
		set_block_level(true)
		$HUB.close_tip()

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
	if Engine.editor_hint and get_parent():
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
		set_block_level(true)
		$SoundLevelManager.stop_sound("game")
		$SoundLevelManager.play_sound("win")
		$Player.set_win()

func _goAction_after_animation(status):
	if status == "read":
		$SoundLevelManager.play_sound("book")
		$HUB.view_book()
		set_block_level(false)
	if status == "win":
		$HUB.set_movements_GUI(DataManager.get_movements())
		$HUB.next_gui()
	if status == "pick":
		set_block_level(false)
		$HUB.set_open_book(true)
		$HUB.show_tip("Presionar (R)", $Player.position)

func set_block_level(status):
	EventManager.level_block = status

func _on_Track_body_entered(body):
	if(body.is_in_group("Players")):
		set_block_level(true)
		$SoundLevelManager.play_sound("track")
		$HUB.set_page_book($Track.description_track)
		$Player.set_pick()
		$Track.queue_free()
