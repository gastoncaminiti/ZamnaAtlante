extends Control

signal level_changed

func set_movements(new_value):
	$MainVerticalContainer/MainHorizontalContainer/MarginMovesContainer/MovesVerticalContainer/Moves.text = String(new_value)

func _on_NextBt_pressed():
	emit_signal("level_changed")
