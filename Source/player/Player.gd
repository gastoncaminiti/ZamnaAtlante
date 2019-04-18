extends KinematicBody2D

var move_x
var move_y

var flag_run

func _ready():
	move_x = 0
	move_y = 0
	flag_run = false
	
func _process(delta):
	move_y += 10
	if (Input.is_action_pressed("move_right")):
		$Sprite.flip_h = true
		flag_run = true	
		move_x = -200
		$Position2D.position.x = -abs($Position2D.position.x)
		$Position2D.rotation = deg2rad(180)
	elif (Input.is_action_pressed("move_left")):
		$Sprite.flip_h = false
		flag_run = true	
		$Position2D.rotation = deg2rad(0)
		$Position2D.position.x = abs($Position2D.position.x)
		move_x = 200
	else:
		move_x = 0
		flag_run = false
		
	if(flag_run):
		if($AnimationPlayer.current_animation != "Run"):
			$AnimationPlayer.play("Run")
	else:
		$AnimationPlayer.play("Idle")
	move_and_slide(Vector2(move_x,move_y), Vector2(0,-1))
