extends CharacterBody2D

@onready var body: Node2D = $body
@onready var turn_left: Node2D = $turn_left
@onready var turn_right: Node2D = $turn_right

@onready var directionNode: Polygon2D = $direction
@onready var hitbox: Area2D = $hitbox

@onready var shield_polygon_2d: CollisionPolygon2D = $shield/shieldArea/ShieldPolygon2D
@onready var shield: Node2D = $shield

var angle : float
const maxAngle := 0.1

const baseSpeed := 300.0
var speed := 300.0

var haveShield : bool = 0

func getInput():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("speed_boost") && speed == baseSpeed:
		speed = 450
	
	if speed > 300:
		speed -= 1
	if speed < baseSpeed:
		speed = baseSpeed
	
	if getInput():
		directionNode.look_at(global_position + getInput())
	
	_shieldSystem()
	_rotation()
	move_and_slide()

func _shieldSystem():
	if haveShield:
		shield.show()
		shield_polygon_2d.disabled = false
	else:
		shield.hide()
		shield_polygon_2d.disabled = true

func _rotation(): 
	velocity = transform.x * speed
	#velocity = Vector2.ZERO
	angle = directionNode.rotation
	if angle < 0 && angle < -maxAngle:
		angle = -maxAngle
		body.hide()
		turn_left.show()
	elif angle > 0 && angle > maxAngle:
		angle = maxAngle
		body.hide()
		turn_right.show()
	else:
		turn_left.hide()
		turn_right.hide()
		body.show()
	rotate(angle)
	directionNode.rotate(-angle)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("rockets"):
		queue_free()
		Game.end()
	elif area.get_parent().is_in_group("powerups"):
		pass

func _on_shield_area_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("rockets"):
		haveShield = 0
