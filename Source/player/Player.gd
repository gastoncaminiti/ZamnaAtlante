extends KinematicBody2D

export (int) var run_speed
export (int) var gravity

var velocity = Vector2()
var flag_status

signal animation_finished

func _ready():
	connect_event_manager("player_moved","_goMove")
	$AnimationPlayer.play("Idle")

func _physics_process(delta):
	velocity.y += gravity * delta
	var collision = move_and_collide(velocity * delta,false)
	if collision:
		velocity.y = 0
		velocity = velocity.slide(collision.normal)
		flag_status = "floor"
	else:
		flag_status = "none"
		

func _process(_delta):
	print(flag_status)
	print(velocity)
	if velocity.x != 0 and velocity.y == 0:
		$AnimationPlayer.play("Run")
	if velocity.x == 0 and $AnimationPlayer.current_animation == "Run":  
		$AnimationPlayer.play("Stop")
	if  flag_status != "floor" and velocity.y > 10:
		$AnimationPlayer.play("Jump")
	

func _goMove(status):
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

func is_on_platform():
	pass

# Función que permite conectar un señal del manejador de eventos con una función de control del jugador.
func connect_event_manager(nsignal, nfunction):
	if EventManager.connect(nsignal,self,nfunction) != OK:
		print("Error al conectar "+ name +" con el manejador de eventos - Señal "+nsignal+" Función "+nfunction)

func _on_AnimationPlayer_animation_started(anim_name):
	if(anim_name == "Win"):
		velocity.x = 0
