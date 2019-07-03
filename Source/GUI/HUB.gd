tool
extends CanvasLayer

export(PackedScene)  var next_scene
export(bool)  var need_tips = false

var open_book = false

func status_gui_sunmoon(new_status):
	$GUI.notification_sunmoon("Night" if new_status else "Day")

func transition_gui_sunmoon(new_status):
	$GUI.notification_sunmoon( "NightToDay" if new_status else "DayToNight")

func status_gui_zanma(new_status):
	$GUI.notification_zanma("Future" if new_status  else "Past")

func transition_gui_zanma(new_status):
	$GUI.notification_zanma("PastToFuture" if new_status else "FutureToPast")

func set_gui_day(new_day):
	$GUI.notification_day(new_day)

func view_book():
	if is_open_book():
		$Book.set_visible(true)

func set_open_book(status):
	open_book = status

func is_open_book():
	return open_book

func is_visible_book():
	return $Book.get_visible()

func set_page_book(new_description):
	$Book.set_page(new_description)
	$Book.set_page_data()

func show_tip(new_tip, new_pos):
	if  need_tips:
		$Tip.position = Vector2(new_pos.x, new_pos.y - $Tip/Background.rect_size.y)
		$Tip/Text.text = new_tip
		$Tip.set_visible(true)

func close_tip():
	if  need_tips:
		$Tip.set_visible(false)

func next_gui():
	$NextLevelGUI.set_visible(true)

func _on_NextLevelGUI_level_changed():
	if(next_scene):
		return get_tree().change_scene_to(next_scene)
