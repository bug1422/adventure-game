extends Node2D

@export var items : Array[Item]

func _ready():
	seed_item()
	
func seed_item():
	
	
	print("start seeding")
	var id = 0
	print("end seeding")
