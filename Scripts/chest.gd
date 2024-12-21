extends Node2D

class_name Chest

@onready var area_2d: Area2D = $Area2D
@onready var closed_state: Sprite2D = $ClosedState
@onready var open_state: Sprite2D = $OpenState

#@export var coin_scene: PickUpItem
@export var loot_stacks = 1
@export var item_to_drop: InventoryItem

var is_open = false
const PICKUP_ITEM = preload("res://Scenes/pickup_item.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_open:
		return
	
	is_open = true
	closed_state.set_visible(false)  # Скрываем закрытый сундук
	open_state.set_visible(true)  # Показываем открытый сундук

	# Создаем монету на месте сундука
	if item_to_drop:
		var loot_drop = PICKUP_ITEM.instantiate() as PickUpItem
		loot_drop.inventory_item = item_to_drop
		loot_drop.stacks = loot_stacks
		
		get_tree().root.add_child(loot_drop)
		loot_drop.global_position = position
		loot_drop.z_index = 10

	# Убираем сундук через некоторое время
	#queue_free()
