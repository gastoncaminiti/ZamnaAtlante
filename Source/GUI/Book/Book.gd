tool
extends TextureRect

export(String) var titulo
export(String) var texto

func _ready():
	$Title.text = titulo
	$Label.text = texto
