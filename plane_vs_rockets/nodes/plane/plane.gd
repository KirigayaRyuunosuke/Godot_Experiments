extends CharacterBody2D

var angle
const maxAngle = 0.1

const speed = 300.0
var speedVector: Vector2

func getInput():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _physics_process(delta: float) -> void:
	if getInput():
		speedVector = getInput()
	velocity = speedVector * speed
	angle = get_angle_to(global_position+speedVector)
	if angle < 0 && angle < -maxAngle:
		angle = -maxAngle
	if angle > 0 && angle > maxAngle:
		angle = maxAngle
	rotate(angle)
	move_and_slide()
