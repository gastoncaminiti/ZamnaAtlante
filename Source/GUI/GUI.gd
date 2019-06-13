tool
extends Control

func notification_sunmoon(new_anim):
	$SunMoonContainer/SunMoon/AnimationPlayer.play(new_anim)

func notification_zanma(new_anim):
	$ZamnaContainer/Zamna/AnimationPlayer.play(new_anim)

func notification_day(new_day):
	$NumberContainer/Number.set_text(String(new_day))