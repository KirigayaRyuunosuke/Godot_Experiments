extends Node2D

var bulletNode = preload("res://MoveTest/bullet.tscn")

func _input(event: InputEvent) -> void:
	if MOUSE_BUTTON_LEFT:
		var bullet = bulletNode.instantiate()
		bullet.global_position = Vector2(500,300)
		add_child(bullet)
