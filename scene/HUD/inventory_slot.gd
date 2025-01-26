@tool
class_name InventorySlot
extends Control

@onready var color_rect = $ColorRect
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
		
var host_cell: InventorySlot
var linked_cell: Array = []
var head_cell: InventorySlot

func _ready() -> void:
	color_rect.visible = false

func highlight():
	$ColorRect.visible = is_hovering

func clear_cell():
	host_cell = null
	linked_cell = []
	is_empty = true


func _on_mouse_entered() -> void:
	is_hovering = true
	toggle_hover_on_linked_cell(true)

func _on_mouse_exited() -> void:
	is_hovering = false
	toggle_hover_on_linked_cell(false)

func toggle_hover_on_linked_cell(value:bool):
	if head_cell:
		head_cell.is_hovering = value
	for cell in linked_cell:
		cell.is_hovering = value

func add_related_cell(linked_cell: Array):
	self.head_cell = linked_cell.pop_front()
	self.linked_cell = linked_cell
	
func add_item_holder(holder:ItemHolder):
	add_child(holder)
