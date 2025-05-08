extends Node2D

@onready var high_score: Label = $CanvasLayer/HighScore

var game := load("res://nodes/main.tscn")


func _physics_process(_delta: float) -> void:
	high_score.text = "High score: " + str(Game.highscore)
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(game)
