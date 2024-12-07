extends CharacterBody2D

class_name Player
@onready var player: Player = $"."

@onready var animated_sprite_2d: AnimationController = $AnimatedSprite2D
@onready var inventory: Inventory = $Inventory

@onready var health_system: HealthSystem = $HealthSystem
@onready var on_screen_ui: OnScreenUI = $OnScreenUI
@onready var combat_system: CombatSystem = $CombatSystem

@export var health = 100

const SPEED = 100.0

func _ready() -> void:
	health_system.init(health)
	health_system.died.connect(on_player_dead)
	health_system.damage_taken.connect(on_damage_taken)
	on_screen_ui.init_health_bar(health)

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if animated_sprite_2d.animation.contains("attack"):
		return
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if velocity != Vector2.ZERO:
		animated_sprite_2d.play_movement_animation(velocity)
	else:
		animated_sprite_2d.play_idle_animation()
		
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PickUpItem:
		inventory.add_item(area.inventory_item, area.stacks)
		area.queue_free()
	
	if area.get_parent() is Enemy:
		if area.name == (area.get_parent() as Enemy).attack_area_2d.name:
			var damage_to_player = (area.get_parent() as Enemy).damage_to_player
			health_system.apply_damage(damage_to_player)
		elif area.name == (area.get_parent() as Enemy).trigger_area_2d.name:
			(area.get_parent() as Enemy).is_aggred = true
			(area.get_parent() as Enemy).chase_player(player)

func on_damage_taken(damage: int) -> void:
	on_screen_ui.apply_damage_to_health_bar(damage)
	
func on_player_dead():
	set_physics_process(false)
	combat_system.set_process_input(false)
	animated_sprite_2d.play("dead")
	
func setup_test_inventory():
	const SWORD_INVENTORY_ITEM = preload("res://Resources/Weapons/Sword/sword_inventory_item.tres")
	const GOLD_COIN = preload("res://Resources/gold_coin.tres")
	
	inventory.add_item(SWORD_INVENTORY_ITEM, 1)
	inventory.add_item(GOLD_COIN, 100)
