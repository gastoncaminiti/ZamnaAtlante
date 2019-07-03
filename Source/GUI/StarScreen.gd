extends Node2D

export(PackedScene)  var open_scene

func _ready():
	$Ema/AnimationPlayer.play("Stand")

func _on_Button_pressed():
	if(open_scene):
		return get_tree().change_scene_to(open_scene)