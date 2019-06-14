tool
extends Node2D

export(PackedScene)  var stem
export(int) var length_stem setget set_leght_plant
export(Vector2) var origin_plant
export(Vector2) var origin_grow 


onready var initPos  = global_position
onready var initGrow =  $GrowPosition2D.position
onready var targetPoint = initPos

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
	position = origin_plant
	$GrowPosition2D.position = origin_grow
	for s in get_tree().get_nodes_in_group("Stem"):
			s.queue_free()
	for i in range(length_stem):
			addsteam(i)
	position -=  $GrowPosition2D.position / 2

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
	var s = stem.instance()
	s.grow($GrowPosition2D)
	add_child(s)
	$GrowPosition2D.position += s.base_point().position
	targetPoint = initPos - s.global_position
	canMove = true
	isGrow = true

func ingrow():
	var s = get_children().back()
	if(s.is_in_group("Stem")):
		s.ingrow()
		targetPoint = s.global_position - s.base_point().global_position
		canMove = true
		isGrow = false
		if($GrowPosition2D.position > initGrow):
			$GrowPosition2D.position -= s.base_point().position

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