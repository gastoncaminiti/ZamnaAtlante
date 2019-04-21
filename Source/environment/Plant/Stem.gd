extends StaticBody2D

func start(position_node):
	$AnimationPlayer.play("Life")
	global_transform = position_node.global_transform
	
func base_point():
	return $Position2D.global_transform

func ingrow():
	$AnimationPlayer.play_backwards("Dead")
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "Dead"):
		queue_free()
	