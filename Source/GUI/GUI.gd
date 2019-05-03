extends CanvasLayer

func notificationSunMoon(anim):
	$SunMoonContainer/SunMoon/AnimationPlayer.play(anim)

func notificationZanma(anim):
	$ZamnaContainer/HBoxContainer/Zamna/AnimationPlayer.play(anim)

func notificationDay(n_day):
	$ZamnaContainer/TextContainer/Label.set_text(String(n_day))