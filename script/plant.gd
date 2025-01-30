extends Resource
class_name Plant
@export var plant_name: String
@export var stages: Array[int]
@export var regrowable: bool
@export var regrow_stage: int = 0
@export var sprite: CompressedTexture2D
@export var sprite_hframes: int = 1
@export var sprite_vframes: int = 1

@export var dropped_item: DroppedItem
