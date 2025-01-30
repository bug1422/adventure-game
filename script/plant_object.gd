@tool
class_name PlantObject
extends InteractableObject


@export var plant_data: Plant:
	get:
		return plant_data

	set(value):
		plant_data = value
		print(plant_data)
		plant_setup()
		
var cur_stage = 0:
	set(value):
		cur_stage = value
		update_sprite()
var max_stage = 1
var total_frame = 2
var is_grown: bool:
	get:
		return is_grown
	set(value):
		is_grown = value
		update_hint()

var timer: Timer
func _ready() -> void:
	if !Engine.is_editor_hint():
		super()
		plant_setup()
		cur_stage = 0
		max_stage = len(plant_data.stages) - 1 
		timer = Timer.new()
		timer.one_shot = true
		add_child(timer)
		timer.timeout.connect(complete_grow_stage)
		growing()

func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		if is_player_in_range and Input.get_action_strength("pickup"):
			harvest()
		
func plant_setup():
	print(plant_data)
	var sprite2d = get_node("Sprite2D")
	if sprite2d:
		if plant_data:
			sprite2d.texture = plant_data.sprite
			sprite2d.hframes = plant_data.sprite_hframes
			sprite2d.vframes = plant_data.sprite_vframes
			$NameLabel.text = plant_data.plant_name
		else:
			sprite2d.texture = null
			sprite2d.hframes = 1
			sprite2d.vframes = 1
			
func harvest():
	is_player_in_range = false
	is_mouse_in_range = false
	player.add_item_to_inventory(create_instance(plant_data.dropped_item.amount))
	if plant_data.regrowable:
		regrow()
	else:
		#destroy this object maybe
		#self.queue_free()
		0

func create_instance(quantity:int):
	var instance = plant_data.dropped_item.item.duplicate()
	instance.quantity = quantity
	return instance

func update_sprite():
	sprite.frame = cur_stage
	
func growing():
	var duration = plant_data.stages[cur_stage]
	timer.start(duration)

func regrow():
	cur_stage = plant_data.regrow_stage
	growing()

func complete_grow_stage():
	cur_stage = min(cur_stage + 1,max_stage)
	print(self.timer, cur_stage)
	if cur_stage == max_stage:
		is_grown = true
		print("fully grown")
	else:
		growing()

func update_hint():
	hint_label.visible = is_player_in_range && is_grown
