extends CharacterBody2D

var speed = 300

func getInput():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _physics_process(_delta: float) -> void:
	velocity = getInput() * speed
	move_and_slide()
