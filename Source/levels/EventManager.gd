extends Node


func _input(event):
	if(event.is_action_pressed("time_change")):
		get_tree().get_nodes_in_group("Level")[0].timepass()
	if(event.is_action_pressed("to_future")):
		get_tree().get_nodes_in_group("Level")[0].goFuture()
	if(event.is_action_pressed("to_pass")):
		get_tree().get_nodes_in_group("Level")[0].goPass()


