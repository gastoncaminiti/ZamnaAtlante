tool
extends StaticBody2D

func grow(position_node):
	$AnimationPlayer.play("Life")
	transform = position_node.transform
	
func base_point():
	return $BasePosition2D

func ingrow():
	$AnimationPlayer.play("Dead")

func addone(position_node):
	$Sprite.set_frame(2)
	transform = position_node.transform

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "Dead"):
		queue_free()
