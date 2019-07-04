extends Node2D

func play_sound(sound):
	get_node(sound).play()

func stop_sound(sound):
	get_node(sound).stop()