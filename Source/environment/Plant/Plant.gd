tool
extends Node2D

export(PackedScene) var Stem
export(int) var _stemcant

var listSteams

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	 pass


func grow():
	var s = Stem.instance()
	s.start($GrowPosition2D)
	get_parent().add_child(s)
	$GrowPosition2D.global_transform = s.base_point()
	

	
func ingrow():
	var s = get_parent().get_children().back()
	print(s)
	if(s.is_in_group("Stem")):
		$GrowPosition2D.global_transform = s.global_transform
		s.ingrow()
	