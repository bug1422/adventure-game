@tool
class_name InventorySlot
extends Control

@onready var color_rect = $ColorRect
@onready var quantity_rect = $QuantityRect
@onready var texture_rect = $TextureRect

@export var is_empty: bool = true:
	get:
		return is_empty
	set(value):
		is_empty = value
		
@export var is_hovering: bool = false:
	get:
		return is_hovering
	set(value):
		is_hovering = value
		highlight()



var item: Item
var host_cell: InventorySlot
var related_cell: Array = []
var quantity: int = 0:
	get:
		return quantity
	set(value):
		quantity = value
		if quantity_rect:
			quantity_rect.text = "%d" % quantity
			if quantity == 0:
				quantity_rect.visible = false
			else:
				quantity_rect.visible = true
				
func _ready() -> void:
	color_rect.visible = false
	quantity_rect.visible = false

func _on_mouse_entered() -> void:
	is_hovering = true

func _on_mouse_exited() -> void:
	is_hovering = false

func add_item(item:Item):
	self.item = item 
	self.quantity = 1
	texture_rect.texture = item.item_icon

func add_stack(amount: int):
	self.quantity += amount

func add_related_cell(host,arr):
	self.related_cell = arr
	self.host_cell = host
	
func highlight():
	if is_hovering:
		$ColorRect.visible = true
	else:
		$ColorRect.visible = false
	for cell in related_cell:
		cell.is_hovering = is_hovering
	if host_cell and self != host_cell:
		host_cell.is_hovering = is_hovering
