tool
extends CanvasLayer

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