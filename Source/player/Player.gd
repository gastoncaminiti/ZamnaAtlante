extends KinematicBody2D

export (int) var run_speed
export (int) var gravity

var velocity = Vector2()
var UP = Vector2(0, -1)
var SNAP = Vector2(0, 32)
var ANGLE = rad2deg(45)

var flag_status

signal animation_finished

func _ready():
	connect_event_manager("player_moved","_goMove")
	flag_status = "ready"

func _physics_process(_delta):
	if !is_on_floor():
		velocity.y = gravity
	velocity = move_and_slide_with_snap(velocity, SNAP, UP, false, 4, ANGLE,false)

func _process(_delta):
	if is_on_floor():
		if flag_status == "right" or flag_status == "left":
			$AnimationPlayer.play("Run")
		if flag_status == "none" and is_anim("Run"):  
			$AnimationPlayer.play("Stop")
	else:
		$AnimationPlayer.play("Jump")
		
	if flag_status == "ready":
		$AnimationPlayer.play("Idle")

	
func _goMove(status):
	if status == "right":
		velocity.x = run_speed
		$Sprite.flip_h = false
	if status == "left":
		velocity.x = -run_speed
		$Sprite.flip_h = true
	if status == "none":
		velocity.x = 0
	flag_status = status

func AnimPlay(anim_name):
	$AnimationPlayer.play(anim_name)
	
func is_anim(anim_name):
	return $AnimationPlayer.current_animation == anim_name

func set_win():
	velocity.x = 0
	AnimPlay("Win")
	flag_status = "win"

func set_pick():
	velocity.x = 0
	AnimPlay("Pick")
	flag_status = "pick"

func _on_AnimationPlayer_animation_started(anim_name):
	if(anim_name == "Read"):
		$AnimationPlayer.playback_speed = 0.4

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "Stop"):
		$AnimationPlayer.play("Idle")
	if(anim_name == "Win"):
		emit_signal("animation_finished", "win")
	if(anim_name == "Read"):
		$AnimationPlayer.playback_speed = 0.2
		emit_signal("animation_finished", "read")
		$AnimationPlayer.play("Idle")
	if(anim_name == "Pick"):
		emit_signal("animation_finished", "pick")
		$AnimationPlayer.play("Idle")

# Función que permite conectar un señal del manejador de eventos con una función de control del jugador.
func connect_event_manager(nsignal, nfunction):
	if EventManager.connect(nsignal,self,nfunction) != OK:
		print("Error al conectar "+ name +" con el manejador de eventos - Señal "+nsignal+" Función "+nfunction)
