tool
extends Control

export(String) var titulo
export(String) var texto

func _ready():
	$PageContainer/Title.text = titulo
	$PageContainer/Text.text = texto
	