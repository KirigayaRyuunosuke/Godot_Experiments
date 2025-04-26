extends CharacterBody2D

@onready var direction: Node2D = $direction

var angle
const maxAngle = 0.05
var speed = 300

func getInput():
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func _physics_process(_delta: float) -> void:
	direction.rotation = get_angle_to(self.position + getInput())
	angle = get_angle_to(direction.get_child(0).global_position)
	print(angle)
	if angle < 0 && angle < -maxAngle:
		angle = -maxAngle
	if angle > 0 && angle > maxAngle:
		angle = maxAngle
	rotate(angle)
	if angle < 0.0001 && angle >= 0 || angle > -0.0001 && angle <= 0:
		pass
	velocity = getInput() * speed
	move_and_slide()
