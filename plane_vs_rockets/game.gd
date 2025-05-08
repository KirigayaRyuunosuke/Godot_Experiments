extends Node

var database : SQLite

var rockets := [
	preload("res://nodes/rockets/normal/rocket.tscn"),
	preload("res://nodes/rockets/multiplicator/rocket.tscn")
]

var explosion := preload("res://nodes/misc/explosion.tscn")

var powerups:= [
	preload("res://nodes/power_ups/shield/shield.tscn"),
	preload("res://nodes/power_ups/speed_boost/speed_boost.tscn")
]

var plane : CharacterBody2D
var main : Node2D

var points := 0
var highscore := 0

func _ready() -> void:
	_initDatabase()
	highscore = _getHighScore()

func end():
	var data = { "score" : points }
	database.insert_row("sessions", data)
	highscore = _getHighScore()
	points = 0
	call_deferred("change_scene_deferred")

func change_scene_deferred():
	get_tree().change_scene_to_file("res://nodes/menu/end.tscn")

func _initDatabase():
	database = SQLite.new()
	database.path = "res://score.db"
	database.open_db()
	if !database.query("SELECT * FROM sessions"):
		_createTableSessions()

func _getHighScore():
	database.query("SELECT score FROM sessions ORDER BY score DESC LIMIT 1")
	if database.query_result.size() :
		return database.query_result[0]["score"]

func _createTableSessions():
	database.create_table("sessions",
		{
			"id": {"data_type":"int","primary_key":true,"not_null":true, "auto_increment":true},
			"score": {"data_type":"int","not_null":true}
		}
	)
