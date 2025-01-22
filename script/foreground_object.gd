@tool
class_name ForegroundObject
extends Node2D

@onready var sprite = $Sprite2D
@onready var name_label = $NameLabel
@onready var hint_label = $HintLabel

@export var item_name: String = "object"

@export var is_mouse_in_range: bool = false:
	get:
		return is_mouse_in_range
	set(value):
		is_mouse_in_range = value
		name_label.visible = is_mouse_in_range

func _ready() -> void:
	name_label.text = item_name
	name_label.visible = false
	hint_label.visible = false

func _on_mouse_entered() -> void:
	is_mouse_in_range = true


func _on_mouse_exited() -> void:
	is_mouse_in_range = false
