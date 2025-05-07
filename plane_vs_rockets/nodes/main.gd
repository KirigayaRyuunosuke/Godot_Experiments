extends Node2D

@onready var plane: CharacterBody2D = $plane
@onready var score: Label = $UI/score
@onready var rockets: Node2D = $rockets
@onready var fps: Label = $UI/fps

func _ready() -> void:
	Game.plane = plane
	Game.main = self

func _process(_delta: float) -> void:
	score.text = "SCORE: " + str(Game.points)
	fps.text = str(Engine.get_frames_per_second())
