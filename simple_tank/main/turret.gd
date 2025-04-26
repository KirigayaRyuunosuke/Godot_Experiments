extends CharacterBody2D

var angle
const maxAngle = 0.025

func _physics_process(_delta: float) -> void:
	angle = get_angle_to(get_global_mouse_position())
	if angle < 0 && angle < -maxAngle:
		angle = -maxAngle
	if angle > 0 && angle > maxAngle:
		angle = maxAngle
	rotate(angle)
