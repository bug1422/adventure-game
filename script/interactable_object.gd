class_name InteractableObject
extends ForegroundObject

@export var is_player_in_range: bool = false:
	get:
		return is_player_in_range
	set(value):
		is_player_in_range = value
		hint_label.visible = is_player_in_range
var player: Player = null

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_in_range = true
		player = body
		

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_in_range = false
		player = null
