extends KinematicBody2D

export (int) var run_speed = 100
export (int) var gravity = 1200

var velocity = Vector2()

func _ready():
	connect_event_manager("player_moved","_goMove")
	
#func _process(delta):
#	if(!flag_win):
#		move_y += 10
#		if (Input.is_action_pressed("move_right")):
#			$Sprite.flip_h = true
#			flag_run = true	
#			move_x = -200
#			$Position2D.position.x = -abs($Position2D.position.x)
#			$Position2D.rotation = deg2rad(180)
#		elif (Input.is_action_pressed("move_left")):
#			$Sprite.flip_h = false
#			flag_run = true	
#			$Position2D.rotation = deg2rad(0)
#			$Position2D.position.x = abs($Position2D.position.x)
#			move_x = 200
#		else:
#			move_x = 0
#			flag_run = false
#
#		if(flag_run):
#			if($AnimationPlayer.current_animation != "Run"):
#				$AnimationPlayer.play("Run")
#		else:
#			$AnimationPlayer.play("Idle")
#		move_and_slide(Vector2(move_x,move_y), Vector2(0,-1))
func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

func _process(_delta):
	if(abs(velocity.x) >= run_speed):
		$AnimationPlayer.play("Run")
	if(velocity.x == 0):  
		$AnimationPlayer.play("Idle")
		
func _goMove(status):
	if status == "right":
		velocity.x = run_speed
		$Sprite.flip_h = false
	if status == "left":
		velocity.x = -run_speed
		$Sprite.flip_h = true

# Función que permite conectar un señal del manejador de eventos con una función de control del jugador.
func connect_event_manager(nsignal, nfunction):
	if EventManager.connect(nsignal,self,nfunction) != OK:
		print("Error al conectar "+ name +" con el manejador de eventos - Señal "+nsignal+" Función "+nfunction)

func AnimPlay(anim_name):
	$AnimationPlayer.play(anim_name)