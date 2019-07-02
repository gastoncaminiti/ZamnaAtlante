extends Area2D

export(String) var description_track

func _ready():
	$AnimationPlayer.play("Idle")
	print("La pista del nivel es:" + description_track)
