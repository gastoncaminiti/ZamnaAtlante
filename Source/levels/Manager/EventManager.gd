extends Node

signal time_changed
signal past_changed
signal future_changed
signal book_readed
signal player_moved

func _input(event):
	# Si existe un nodo del grupo Level se valida el evento input para emitir la señal acorde.
	if(get_tree().get_nodes_in_group("Level")):
		if(event.is_action_pressed("time_change")):
			emit_signal("time_changed")
		if(event.is_action_pressed("to_future")):
			emit_signal("future_changed")
		if(event.is_action_pressed("to_pass")):
			emit_signal("past_changed")
		if(event.is_action_pressed("read_book")):
			emit_signal("book_readed")
		#if(event.is_action_pressed("exit")):
			#emit_signal("book_readed",false)
		if (Input.is_action_pressed("move_right")):
			emit_signal("player_moved", "right")
		if (Input.is_action_pressed("move_left")):
			emit_signal("player_moved", "left")


