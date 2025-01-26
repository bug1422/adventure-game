extends InteractableObject

@export var hud: InventoryHUD

func _process(delta: float) -> void:
	if is_player_in_range and Input.get_action_strength("pickup"):
		toggle_display(player.get_inventory())
		
func toggle_display(inventory_cells:Array):
	if hud.visible:
		hud.clear_cells()
		hud.visible = false
	else:
		hud.add_to_cells(inventory_cells)
		hud.visible = true
