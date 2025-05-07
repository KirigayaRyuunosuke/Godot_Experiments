extends Node

var rockets = [
	preload("res://nodes/rockets/normal/rocket.tscn"),
	preload("res://nodes/rockets/multiplicator/rocket.tscn")
]

var explosion = preload("res://nodes/misc/explosion.tscn")

var plane
var main

var points = 0

func end():
	points = 0
	get_tree().change_scene_to_file("res://nodes/menu/end.tscn")

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass
