extends Node2D

var game = load("res://nodes/main.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(game)
