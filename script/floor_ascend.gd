extends Area2D


var z_value = 0
var z_offset_value = 2

func _ready() -> void:
	var parent = get_parent()
	if parent and parent is CanvasItem:
		z_value = parent.z_index
	print(z_value)

func _on_body_entered(body: Node2D) -> void:
	body.z_index = z_value + z_offset_value
	print(body.z_index)
	
	
