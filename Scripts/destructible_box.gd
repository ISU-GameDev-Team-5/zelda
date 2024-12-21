extends Node2D

class_name DestructibleBox

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D

func destroy():
	# Отключаем коллизии
	static_body_2d.set_collision_layer_value(10, false)
	static_body_2d.set_collision_mask_value(1, false)
	area_2d.set_collision_layer_value(11, false)
	area_2d.set_collision_mask_value(5, false)
	
	# Прячем основной спрайт
	sprite_2d.visible = false
	
	#animated_sprite_2d.play("destroy")
	#await animated_sprite_2d.animation_finished
	
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	destroy()
