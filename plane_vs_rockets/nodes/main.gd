extends Node2D

@onready var plane: CharacterBody2D = $plane
@onready var score: Label = $UI/score

func _ready() -> void:
	Game.plane = plane
	Game.main = self

func _process(_delta: float) -> void:
	score.text = "SCORE: " + str(Game.points)
