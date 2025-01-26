extends TextureRect
class_name ItemHolder

var item: Item:
	get:
		return item
	set(value):
		item = value
		if item == null:
			quantity = 0
			texture = null
		else:
			quantity = item.quantity
			holder_matrix = item.grid_matrix
			texture = item.item_icon

var quantity: int = 0:
	get:
		return quantity
	set(value):
		quantity = value
		if $QuantityRect:
			$QuantityRect.text = "%d" % quantity
			if quantity == 0:
				$QuantityRect.visible = false
			else:
				$QuantityRect.visible = true

var relative_cell: Array[Vector2] = []

var start_cell: Vector2 = Vector2(-1,-1):
	get:
		return start_cell
	set(value):
		start_cell = value
		if holder_matrix and value.x >= 0 and value.y >= 0:
			relative_cell = []
			for y in range(0,len(holder_matrix)):
				for x in range(0,len(holder_matrix[y])):
					if holder_matrix[y][x] == 1:
						relative_cell.append(Vector2(x,y)+start_cell)

@export var holder_matrix: Array = [[1]]

func check_item(item:Item):
	return self.item.get_id() == item.get_id()
	
func add_stack(item:Item):
	self.item.quantity += item.quantity
	self.quantity = self.item.quantity
