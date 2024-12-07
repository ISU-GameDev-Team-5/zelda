extends AnimatedSprite2D

class_name EnemyAnimatedSprite2D
@onready var trigger_area_2d: Area2D = $"../TriggerArea2D"
@onready var trigger_collision_shape_2d: CollisionShape2D = $"../TriggerArea2D/CollisionShape2D"

const MOVEMENT_TO_IDLE = {
	"back_walk": "back_idle",
	"front_walk": "front_idle",
	"right_walk": "right_idle",
	"left_walk": "left_idle"
}

var last_direction: Vector2 = Vector2.ZERO

func play_movement_animation(direction: Vector2):
	if direction.distance_squared_to(last_direction) < 0.01:
		return
	last_direction = direction
	if direction.x > 0 and absf(direction.x) > absf(direction.y):
		play("right_walk")
		_update_trigger_position()
		return
	elif direction.x < 0 and absf(direction.x) > absf(direction.y):
		play("left_walk")
		_update_trigger_position()
		return
	if direction.y > 0 and absf(direction.y) > absf(direction.x):
		play("front_walk")
		_update_trigger_position()
		return
	elif direction.y < 0 and absf(direction.y) > absf(direction.x):
		play("back_walk")
		_update_trigger_position()
		return
		
func play_idle_animation():
	if MOVEMENT_TO_IDLE.keys().has(animation):
		play(MOVEMENT_TO_IDLE[animation])

func _update_trigger_position():
	# Приводим направление к строго вертикальному или горизонтальному
	var normalized_direction = Vector2()

	if last_direction.x > 0:
		normalized_direction.x = 1
	elif last_direction.x < 0:
		normalized_direction.x = -1
	if last_direction.y > 0:
		normalized_direction.y = 1
	elif last_direction.y < 0:
		normalized_direction.y = -1
	# Вычисляем смещение
	var offset = normalized_direction * 10
	trigger_collision_shape_2d.global_position = global_position + offset
