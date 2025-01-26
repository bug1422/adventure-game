extends Node

@onready var item_holder = preload("res://scene/HUD/item_holder.tscn")


func create_item_holder(item:Item):
	var item_holder_scene = self.item_holder.instantiate()
	(item_holder_scene as ItemHolder).item = item
	return item_holder_scene
