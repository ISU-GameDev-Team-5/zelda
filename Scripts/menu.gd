extends CanvasLayer

@onready var play: Button = $VBoxContainer/Play
@onready var exit: Button = $VBoxContainer/Exit
@onready var texture_rect: TextureRect = $TextureRect


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
