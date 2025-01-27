extends InventorySlot
class_name ItemHolder

@onready var texture_rect = $TextureRect
var item: Item:
	get:
		return item
	set(value):
		item = value
		if item == null:
			quantity = 0
			$TextureRect.texture = null
		else:
			quantity = item.quantity
			$TextureRect.texture = item.item_icon

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

var is_holding: bool = false:
	get:
		return is_holding
	set(value):
		is_holding = value
		highlight()
		
func check_item(item:Item):
	return self.item.get_id() == item.get_id()
	
func add_stack(item:Item):
	self.item.quantity += item.quantity
	self.quantity = self.item.quantity

func highlight():
	$ColorRect.visible = is_hovering && !is_holding
