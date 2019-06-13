tool
extends Control

export(String) var titulo setget set_titulo
export(String) var texto  setget set_texto

func _ready():
	set_page_data()

func set_page_data():
	$PageContainer/Title.text = titulo
	$PageContainer/Text.text = texto

func set_titulo(new_value):
	titulo = new_value

func set_texto(new_value):
	texto = new_value