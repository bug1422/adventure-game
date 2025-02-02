class_name Player
extends CharacterBody2D

@export var speed = 80
@onready var anim_tree = $AnimationTree
@onready var inventory_manager:InventoryHUD = $CanvasLayer/Inventory

var prev_input = Vector2.ZERO
var cur_input = Vector2.ZERO

var is_punching = false
var is_opening_hud = false

func _ready() -> void:
	
	pass
	
func _physics_process(delta: float) -> void:
	get_input()
	update_movement()
	pass
	
func get_input():
	cur_input = Vector2(Input.get_axis("left","right"),Input.get_axis("up","down"))
	if cur_input != Vector2.ZERO:
		anim_tree.change_state_walk()
		prev_input = cur_input
	else:
		anim_tree.change_state_idle()
	get_action_input()
	anim_tree.update_blend_value(prev_input.x,prev_input.y)

func get_action_input():
	if Input.get_action_strength("action"):
		anim_tree.change_state_punch()
		cur_input = Vector2.ZERO
		is_punching = true
		await anim_tree.animation_finished
		is_punching = false

func update_movement():
	if !is_doing_action():
		velocity = speed * cur_input
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func is_doing_action():
	var is_doing_stuff = (
		is_punching or 
		is_opening_hud
	)
	return is_doing_stuff
	
func add_item_to_inventory(item:Item):
	inventory_manager.add_item(item)
	
func get_inventory():
	return inventory_manager.get_inventory()
