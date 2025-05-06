extends CharacterBody2D

@onready var directionNode: Polygon2D = $direction
@onready var hitbox: Area2D = $hitbox

var angle
const maxAngle = 0.1

const speed = 300.0

func getInput():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _physics_process(delta: float) -> void:
	if getInput():
		directionNode.look_at(global_position + getInput())
	velocity = transform.x * speed
	#velocity = Vector2.ZERO
	angle = directionNode.rotation
	if angle < 0 && angle < -maxAngle:
		angle = -maxAngle
	if angle > 0 && angle > maxAngle:
		angle = maxAngle
	rotate(angle)
	directionNode.rotate(-angle)
	move_and_slide()


func _on_hitbox_area_entered(area: Area2D) -> void:
	print(area.get_parent().name)
