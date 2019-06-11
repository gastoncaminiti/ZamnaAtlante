tool
extends Control

func notificationSunMoon(anim):
	$SunMoonContainer/SunMoon/AnimationPlayer.play(anim)

func notificationZanma(anim):
	$ZamnaContainer/Zamna/AnimationPlayer.play(anim)

func notificationDay(n_day):
	$NumberContainer/Number.set_text(String(n_day))