extends KinematicBody2D

export (int) var run_speed = 100
export (int) var gravity = 1200

var velocity = Vector2()

signal animation_finished

func _ready():
	connect_event_manager("player_moved","_goMove")
	$AnimationPlayer.play("Idle")

func _physics_process(delta):
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity, Vector2(0, -1))

func _process(_delta):	
	if($AnimationPlayer.current_animation != "Win"):
		if(velocity.x != 0):
			$AnimationPlayer.play("Run")
		if(velocity.x == 0 and $AnimationPlayer.current_animation == "Run"):  
			$AnimationPlayer.play("Stop")

func _goMove(status):
	if($AnimationPlayer.current_animation != "Win"):
		if status == "right":
			velocity.x = run_speed
			$Sprite.flip_h = false
		if status == "left":
			velocity.x = -run_speed
			$Sprite.flip_h = true
		if status == "none":
			velocity.x = 0

func AnimPlay(anim_name):
	$AnimationPlayer.play(anim_name)

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "Stop"):
		$AnimationPlayer.play("Idle")
	if(anim_name == "Win"):
		emit_signal("animation_finished", "win")
	if(anim_name == "Read"):
		emit_signal("animation_finished", "read")
		$AnimationPlayer.play("Idle")

# Función que permite conectar un señal del manejador de eventos con una función de control del jugador.
func connect_event_manager(nsignal, nfunction):
	if EventManager.connect(nsignal,self,nfunction) != OK:
		print("Error al conectar "+ name +" con el manejador de eventos - Señal "+nsignal+" Función "+nfunction)