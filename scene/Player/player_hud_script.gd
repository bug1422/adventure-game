extends CanvasLayer

var parent: Player

var inventory_dict : Dictionary = {}

func _ready() -> void:
	$Inventory.visible = false
	parent = get_parent()
	if not parent or  "is_opening_hud" not in parent: 
		print("no variable")
	else:
		print("HUD ready")
		


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		$Inventory.visible = !$Inventory.visible
		parent.is_opening_hud = !parent.is_opening_hud
