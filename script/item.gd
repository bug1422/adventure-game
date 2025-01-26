class_name Item
extends Resource

enum RARITY {
	COMMON,
	UNCOMMON,
	RARE,
	EXOTIC
}

var id: int
var quantity: int
@export var rarity: RARITY
@export var item_name: String
@export var description: String
@export var item_icon: CompressedTexture2D
@export var stackable: bool:
	get:
		return stackable
	set(value):
		stackable = value
		if not stackable:
			stack_max_count = 1
@export var stack_max_count: int:
	get:
		return stack_max_count
	set(value):
		print(value)
		if not stackable:
			stackable = 1
		else:
			stackable = value
@export var grid_size: Vector2 = Vector2(1,1):
	get:
		return grid_size
	set(value):
		grid_size = value
		var y_row = []
		for y in grid_size.y:
			var x_row = []
			for x in grid_size.x:
				x_row.append(0)
			y_row.append(x_row)
		grid_matrix = y_row
		
@export var grid_matrix: Array = [[1]]:
	get:
		return grid_matrix
	set(value):
		if len(value) == grid_size.y and len(value[0]) == grid_size.x:
			grid_matrix = value


func from_dict(data:Dictionary) -> void:
	id = data.get("id")
	rarity = parse_rarity(data.get("rarity", "COMMON"))
	item_name = data.get("item_name")
	description = data.get("description")
	stackable = data.get("stackable")
	stack_max_count = data.get("stack_max_count")
	grid_size = data.get("grid_size")
	grid_matrix = data.get("grid_matrix")

func to_dict() -> Dictionary:
	return {
		"id": id,
		"rarity": rarity_to_string(rarity),
		"item_name": item_name,
		"description": description,
		"stackable": stackable,
		"stack_max_count": stack_max_count,
		"grid_size": grid_size,
		"grid_matrix": grid_matrix
	}

func parse_rarity(rarity_string: String) -> RARITY:
	match rarity_string.to_upper():
		"COMMON":
			return RARITY.COMMON
		"UNCOMMON":
			return RARITY.UNCOMMON
		"RARE":
			return RARITY.RARE
		"EXOTIC":
			return RARITY.EXOTIC
		_:
			push_warning("Unknown rarity: %s, defaulting to COMMON" % rarity_string)
			return RARITY.COMMON
			
func rarity_to_string(rarity_enum: RARITY) -> String:
	match rarity_enum:
		RARITY.COMMON:
			return "COMMON"
		RARITY.UNCOMMON:
			return "UNCOMMON"
		RARITY.RARE:
			return "RARE"
		RARITY.EXOTIC:
			return "EXOTIC"
		_:
			return "UNKNOWN"

func get_id():
	if stackable:
		return item_name
	else:
		return id
