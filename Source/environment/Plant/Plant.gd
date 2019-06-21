tool
extends Node2D

export(PackedScene)  var stem
export(int) var length_stem setget set_leght_plant
export(Vector2) var origin_plant
export(Vector2) var origin_grow 
export(Vector2) var targetPoint



var canMove
var isGrow


func _ready():
	connect_parent_child("plants_growed","grow")
	connect_parent_child("plants_decreased","ingrow")
	connect_parent_child("plants_stoped","timeEnd")
	generate_plant()
	canMove = false
	isGrow = false


func generate_plant():
	global_position = origin_plant
	$GrowPosition2D.position = origin_grow
	for s in get_tree().get_nodes_in_group("Stem"):
			s.queue_free()
	for i in range(length_stem):
			addsteam(i)
	global_position  -=  $GrowPosition2D.position / 2
	

func addsteam(index):
	var new_stem = stem.instance()
	new_stem.addone($GrowPosition2D)
	new_stem.position = $GrowPosition2D.position
	$GrowPosition2D.position += new_stem.base_point().position
	add_child(new_stem)
	print("Agregado el tronco "+str(index))

func set_leght_plant(new_value):
	length_stem = new_value
	if(get_parent() != null):
		generate_plant()

func grow():
	var new_stem = stem.instance()
	new_stem.grow($GrowPosition2D)
	$GrowPosition2D.position += new_stem.base_point().position
	add_child(new_stem)
	canMove = true
	isGrow = true

func ingrow():
	var last_stem = get_children().back()
	if(last_stem.is_in_group("Stem")):
		last_stem.ingrow()
		if($GrowPosition2D.position > origin_grow):
			$GrowPosition2D.position -= last_stem.base_point().position
		canMove = true
		isGrow = false

func _process(delta):
	
	if(canMove):
		if(isGrow):
			global_position += targetPoint * delta 
		else:
			global_position -= targetPoint * delta 

func timeEnd():
	canMove = false
	
# Función que permite conectar una señal de nodo padre con una función del nodo hijo.
func connect_parent_child(nsignal, nfunction):
	if get_parent().is_in_group("Level"):
		if get_parent().connect(nsignal,self,nfunction) != OK:
			print("Error al conectar "+ name +" con el padre - Señal "+nsignal+" Función "+nfunction)