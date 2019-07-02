extends Control

var TITLE = "NOTA DE CAMPO"
export(String) var page  setget set_page

func set_page_data():
	$PageContainer/Title.text = TITLE
	$PageContainer/Text.text = page

func set_page(new_value):
	page = new_value