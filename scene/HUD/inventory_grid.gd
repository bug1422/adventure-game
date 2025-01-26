extends Control
class_name  InventoryHUD
@onready var grid_container = $GridContainer
@onready var holding_item_icon: TextureRect = $HoldingItemIcon
@export var slot_scene: PackedScene = preload("res://scene/HUD/inventory_hud_slot.tscn")

@export var width_size: int = 9
@export var height_size: int = 6

var holding_item: ItemHolder

var cells: Array = []
var item_holders: Array[ItemHolder] = []

func _ready() -> void:
	for y in range(0,height_size):
		var row = []
		for x in range(0,width_size):
			var slot = slot_scene.instantiate() 
			grid_container.add_child(slot)
			slot.gui_input.connect(slot_gui_input.bind(slot))
			row.append(slot)
		cells.append(row)
		print(len(row))
	pass



func slot_gui_input(event: InputEvent, slot: InventorySlot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if holding_item != null:
				if !slot.item:
					slot.add_item(holding_item)
					holding_item =  null
					holding_item_icon.texture = null
				else:
					var tempt_item = slot.item
					slot.clear_cell()
					holding_item_icon.texture = tempt_item.item_icon
					holding_item_icon.global_position = event.global_position
					slot.add_item(holding_item)
					holding_item = tempt_item 
			elif slot.item:
				holding_item = slot.item
				slot.clear_cell()
				holding_item_icon.texture = holding_item.item_icon
				holding_item_icon.global_position = get_global_mouse_position()

func _process(delta: float) -> void:
	if holding_item:
		holding_item_icon.global_position = get_global_mouse_position()

func add_item(holder: ItemHolder):
	var existed_item = item_holders.filter(func(x:ItemHolder): return x.check_item(holder.item))
	if existed_item:
		existed_item.front().add_stack(holder.item)
		return
		
	var cell = check_available(holder.item)
	if cell != null:
		cell.add_item_holder(holder)
		item_holders.append(holder)

func check_available(item:Item) -> InventorySlot:
	
	for y in range(0,height_size-item.grid_size.y):
		for x in range(0,width_size-item.grid_size.x):
			var linked_cell = apply_item(item.grid_matrix,Vector2(x,y),item.grid_size)
			if linked_cell != null or linked_cell != []:
				for cell in linked_cell:
					cell.add_related_cell(linked_cell.duplicate())
				return linked_cell[0]
	return null

func apply_item(matrix,cell_pos:Vector2,matrix_size:Vector2,matrix_pos:Vector2=Vector2.ZERO,linked_cell:Array=[]):
	var cell:InventorySlot = cells[cell_pos.y][cell_pos.x]
	var matrix_cell:int = matrix[matrix_pos.y][matrix_pos.x] 
	if matrix_cell == 1 and cell.is_empty:
		linked_cell.append(cell)
		matrix_pos.x += 1
		if matrix_pos.x == matrix_size.x:
			matrix_pos.y += 1
			if matrix_pos.y == matrix_size.y:
				return linked_cell
			else:
				matrix_pos.x = 0
				return apply_item(matrix,Vector2(cell.x-matrix_size.x+1,cell.y+1),matrix_size,matrix_pos,linked_cell)
		else:
			return apply_item(matrix,Vector2(cell.x+1,cell.y),matrix_size,matrix_pos,linked_cell)
	else:
		return []

func get_inventory():
	return cells
