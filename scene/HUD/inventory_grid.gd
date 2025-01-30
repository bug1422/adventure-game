extends Control
class_name  InventoryHUD
@onready var grid_container = $GridContainer
@onready var item_container = $ItemContainer
@export var slot_scene: PackedScene = preload("res://scene/HUD/inventory_hud_slot.tscn")

@export var width_size: int = 9
@export var height_size: int = 6
@export var slot_size: Vector2 = Vector2(32,32)

var holding_item: ItemHolder
@export var holding_offset: Vector2 = Vector2(4,4)

var slots: Array = []
var inventory_matrix: Array = []
var item_holders: Dictionary = {}
@export var onloadout_items: Array[DroppedItem] = []

func _ready() -> void:
	for y in range(0,height_size):
		var slot_row = []
		var inv_row = []
		for x in range(0,width_size):
			var slot = slot_scene.instantiate() 
			grid_container.add_child(slot)
			slot.gui_input.connect(slot_gui_input.bind(slot))
			slot_row.append(slot)
			inv_row.append(0)
		slots.append(slot_row)
		inventory_matrix.append(inv_row)
	for dropped in onloadout_items:
		var item:Item = dropped.item.duplicate()
		item.quantity = dropped.amount
		add_item(item)



func slot_gui_input(event: InputEvent, slot: InventorySlot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if holding_item:
				var matrix_pos = slot.position / slot_size
				item_holders[holding_item] = slot.position
				holding_item.position = slot.position
				holding_item.is_holding = false
				holding_item = null

func item_gui_input(event: InputEvent, holder: ItemHolder):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			#get item based on slot position
			if holding_item == null:
				holding_item = holder
				holding_item.global_position = get_global_mouse_position() + holding_offset
				holding_item.is_holding = true
			else:
				#check if theres already an item on that position
				holding_item.position = item_holders[holding_item]
				holding_item.is_holding = false
				holding_item = null

func _process(delta: float) -> void:
	if holding_item:
		holding_item.global_position = get_global_mouse_position() + holding_offset

func add_item(item: Item):
	var existed_item = item_holders.keys().filter(func(x:ItemHolder): return x.check_item(item))
	if existed_item:
		existed_item.front().add_stack(item)
		return
		
	var pos = check_available_position(item)
	if pos != null:
		var holder:ItemHolder = OtherGlobalScript.create_item_holder(item)
		item_container.add_child(holder)
		holder.position = pos * slot_size
		holder.gui_input.connect(item_gui_input.bind(holder))
		item_holders[holder] = pos
		apply_to_matrix(pos,item)

func check_available_position(item:Item):
	for y in range(0,height_size):
		for x in range(0,width_size):
			var is_cell_avail = check_available_cell(x,y,item)
			if is_cell_avail:
				return Vector2(x,y)

func check_available_cell(x:int,y:int,item:Item):
	var cell = inventory_matrix[y][x]
	var x_iter = 0
	var y_iter = 0 
	while cell == 0:
		var item_cell = item.grid_matrix[y_iter][x_iter]
		if item_cell == 1:
			cell = inventory_matrix[y+y_iter][x+x_iter]
		elif item_cell == 0:
			cell = 0
		x_iter += 1
		if x_iter >= item.grid_size.x:
			x_iter = 0
			y_iter += 1
		if y_iter >= item.grid_size.y:
			return true
	return false

func apply_to_matrix(position:Vector2,item:Item):
	for y in range(0,item.grid_size.y):
		for x in range(0,item.grid_size.x):
			if item.grid_matrix[y][x] == 1:
				inventory_matrix[position.y][position.x] = 1

func get_inventory():
	pass
