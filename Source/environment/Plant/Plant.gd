tool
extends Node2D

export(PackedScene) var Stem
export(int) var stemcant

var initPos
var initGrow
var targetPoint
var canMove
var isGrow

func _ready():
	initGrow =  $GrowPosition2D.position
	initPos  = global_position
	targetPoint = initPos
	canMove = false
	isGrow = false
	for i in range(stemcant):
		addsteam()

func grow():
	var s = Stem.instance()
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

func addsteam():
	var s = Stem.instance()
	s.addone($GrowPosition2D)
	add_child(s)
	$GrowPosition2D.position += s.base_point().position
	targetPoint = initPos - s.global_position
	global_position += targetPoint

func _process(delta):
	if(canMove):
		if(isGrow):
			global_position += targetPoint * delta 
		else:
			global_position -= targetPoint * delta 

func timeEnd():
	canMove = false