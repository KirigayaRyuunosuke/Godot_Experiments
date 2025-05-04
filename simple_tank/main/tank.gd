extends CharacterBody2D

@onready var direction: Node2D = $direction

var angle
const maxAngle = 0.015
var speed = 150
var multiplier = 35

func getInput():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _physics_process(_delta: float) -> void:
	angle = get_angle_to(self.position + getInput())
	if angle < 0 && angle > -maxAngle*multiplier:
		angle = -maxAngle
		velocity = getInput() * speed
	elif angle > 0 && angle < maxAngle*multiplier:
		angle = maxAngle
		velocity = getInput() * speed
	elif angle < 0 && angle < -maxAngle:
		angle = -maxAngle
		velocity = Vector2(0,0)
	elif angle > 0 && angle > maxAngle:
		angle = maxAngle
		velocity = Vector2(0,0)
	else:
		velocity = getInput() * speed
	move_and_slide()
	self.rotate(angle)
	if angle < 0.0001 && angle >= 0 || angle > -0.0001 && angle <= 0:
		pass
