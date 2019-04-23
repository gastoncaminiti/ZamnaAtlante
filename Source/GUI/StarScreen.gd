extends Node2D


func _ready():
	$Ema/AnimationPlayer.play("Stand")

func _on_Button_pressed():
	get_tree().change_scene("res://levels/Level0/Level0.tscn")