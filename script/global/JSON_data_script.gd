extends Node

var items: Array[Item]
func _ready():
	if LoadData():
		print("Item loaded")
	else:
		print("Can't load item")
	
func LoadData():
	var json_data
	var file_data = FileAccess.open("res://data/ItemData.json", FileAccess.ModeFlags.READ)
	if file_data:
		json_data = JSON.parse_string(file_data.get_as_text())
		file_data.close()
		if json_data and json_data.error == OK:
			for item_data in json_data.result:
				var item = Item.new()
				item.from_dict(item_data)
				items.append(item)
			return true
	return false
	
func add_item(item: Item):
	items.append(item)

func SaveData():
	var json_string = JSON.stringify(items)
	var file_data = FileAccess.open("res://data/ItemData.json", FileAccess.ModeFlags.WRITE)
	if file_data:
		file_data.store_string(json_string)
		file_data.close()
