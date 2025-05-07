extends Node

var database : SQLite

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
	database = SQLite.new()
	database.path = "res://score.db"
	database.open_db()


func _process(_delta: float) -> void:
	pass
