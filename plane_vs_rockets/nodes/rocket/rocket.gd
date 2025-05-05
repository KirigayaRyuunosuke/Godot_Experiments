extends CharacterBody2D

var angle
const maxAngle = 0.025
var speed = 310

func _physics_process(delta: float) -> void:
	velocity = transform.x * speed
	angle = get_angle_to(get_parent().plane.global_position)
	if angle < 0 && angle < -maxAngle:
		angle = -maxAngle
	if angle > 0 && angle > maxAngle:
		angle = maxAngle
	if get_parent().plane.velocity:
		rotate(angle)
		move_and_slide()
