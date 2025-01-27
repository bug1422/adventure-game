class_name InventorySlot
extends Control

@onready var color_rect = $ColorRect
@export var is_hovering: bool = false:
	get:
		return is_hovering
	set(value):
		is_hovering = value
		highlight()

func _ready() -> void:
	color_rect.visible = false

func highlight():
	$ColorRect.visible = is_hovering

func _on_mouse_entered() -> void:
	is_hovering = true

func _on_mouse_exited() -> void:
	is_hovering = false
