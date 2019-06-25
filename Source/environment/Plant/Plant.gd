tool
extends Node2D

export(PackedScene)  var stem
export(int,10) var length_plant
export(int, "None", "Origin Plant","Calibrate Plant","Clean") var action_plant setget action_plant_editor
export(Vector2) var origin_plant

onready var unit_move = global_position - $GrowPosition2D.global_position
onready var canMove = false
onready var isGrow  = false
var origin_grow = Vector2(0,70)



func _ready():
	if not Engine.editor_hint:
		connect_parent_child("plants_growed","grow")
		connect_parent_child("plants_decreased","ingrow")
		connect_parent_child("plants_stoped","timeEnd")
	clean_plant()
	generate_plant()

func _process(delta):
	if(canMove):
		if(isGrow):
			global_position += unit_move * delta 
		else:
			global_position -= unit_move * delta 

#--------Sección de manejo del crecimiento de la planta--------#
#Función de generación de la planta en función del largo definido.
func generate_plant():
	for i in range(length_plant):
			addsteam(i)
	global_position  +=  unit_move * length_plant

#Función que agrega un tronco a la planta.
func addsteam(_index):
	var new_stem = stem.instance()
	new_stem.addone($GrowPosition2D)
	new_stem.position = $GrowPosition2D.position
	$GrowPosition2D.position += new_stem.base_point().position
	add_child(new_stem)

#Función que controla el crecimiento de la planta sumando un tronco. / TRIGGER -> plants_growed
func grow():
	var new_stem = stem.instance()
	new_stem.grow($GrowPosition2D)
	$GrowPosition2D.position += new_stem.base_point().position
	add_child(new_stem)
	canMove = true
	isGrow = true

#Función que controla el decrecimiento de la planta restando un tronco. / TRIGGER -> plants_decreased
func ingrow():
	var last_stem = get_children().back()
	if(last_stem.is_in_group("Stem")):
		last_stem.ingrow()
		if($GrowPosition2D.position > origin_grow):
			$GrowPosition2D.position -= last_stem.base_point().position
		canMove = true
		isGrow = false

#--------Sección de control de estados--------#
#Función SET que acciona el comportamiento de la planta en el modo edición.
func action_plant_editor(new_value):
	if Engine.editor_hint:
		action_plant = new_value
		match action_plant:
			0:
				print("Sin acción")
			1:
				print("Definir posición actual como punto de crecimiento")
				set_origin_plant()
			2:
				print("Calibrado crecimiento a posición origen")
				clean_plant()
				unit_move = global_position - $GrowPosition2D.global_position
				generate_plant()
			3:
				print("Limpiar los troncos")
				clean_plant()

#Función que reinicia la planta a su estado inicial.
func clean_plant():
	global_position = origin_plant
	$GrowPosition2D.position = origin_grow
	for i in get_children():
		if(i.is_in_group("Stem")):
    		i.queue_free()
	
#Función que reinicia la planta a su estado inicial.
func set_origin_plant():
	origin_plant = global_position
	
#Función TRIGGER -> plants_stoped
func timeEnd():
	canMove = false
	
# Función que permite conectar una señal de nodo padre con una función del nodo hijo.
func connect_parent_child(nsignal, nfunction):
	if get_parent().is_in_group("Level"):
		if get_parent().connect(nsignal,self,nfunction) != OK:
			print("Error al conectar "+ name +" con el padre - Señal "+nsignal+" Función "+nfunction)