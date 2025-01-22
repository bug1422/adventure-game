class_name HarvestableObject
extends InteractableObject

@export var is_harvested: bool  = false:
	get:
		return is_harvested
	set(value):
		is_harvested = value
		change_sprite()
		
@export var dropped_item: Item

func _process(delta: float) -> void:
	if is_player_in_range and Input.get_action_strength("pickup"):
		harvest()
		
func harvest():
	is_harvested = true
	is_player_in_range = false
	is_mouse_in_range = false
	player.add_item_to_inventory(dropped_item)
	
	
func change_sprite():
	if is_harvested:
		sprite.frame = 1
	else:
		sprite.frame = 0
	print(sprite,sprite.frame)
