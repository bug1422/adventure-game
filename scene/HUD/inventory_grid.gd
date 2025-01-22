
extends GridContainer

@export var slot_scene: PackedScene

@export var width_size: int = 9
@export var height_size: int = 6


var cells: Array = []
var used_cells: Array = []

func _ready() -> void:
	for y in range(0,height_size):
		var row = []
		for x in range(0,width_size):
			var slot = slot_scene.instantiate() 
			add_child(slot)
			row.append(slot)
		cells.append(row)
		print(len(row))
	pass
	
	
func add_item(item: Item):
	var position = check_available(item)
	if position != null:
		caculate_middle_pos(position,item.grid_size)
	else:
		print("not enough room")

func check_available(item:Item):
	for y in range(0,height_size-item.grid_size.y):
		for x in range(0,width_size-item.grid_size.x):
			var linked_cell = apply_item(item.grid_matrix,Vector2(x,y),item.grid_size)
			if linked_cell != null:
				used_cells.append([item,linked_cell])
				var host: InventorySlot = linked_cell.pop_front() 
				host.add_item(item)
				var l = len(linked_cell)
				for i in range(0,l):
					linked_cell.slice()
					(linked_cell[i] as InventorySlot).add_related_cell(host,linked_cell.slice(0,i) + linked_cell.slice(i+1,l))
				return Vector2(x,y)
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

func caculate_middle_pos(pos,matrix_size):
	pass
