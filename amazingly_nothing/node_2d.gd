extends Node2D

@onready var button: Button = $Button

func _ready() -> void:
	button.connect("pressed", printTest.bind("test"))

func printTest(arg): print(arg)
