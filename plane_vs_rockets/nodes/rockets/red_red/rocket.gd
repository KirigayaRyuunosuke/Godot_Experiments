extends CharacterBody2D

@onready var booster: Polygon2D = $booster
@onready var timer: Timer = $Timer

var angle
const maxAngle = 0.025
var speed = 250

var acceleration = 5
var deacceleration = 3
var accelerating: bool = 1

func _physics_process(delta: float) -> void:
	angle = get_angle_to(Game.plane.global_position)
	if angle < 0 && angle < -maxAngle:
		angle = -maxAngle
	if angle > 0 && angle > maxAngle:
		angle = maxAngle
	
	if accelerating:
		speed += acceleration
	else:
		speed -= deacceleration
		if speed < Game.plane.speed:
			Game.points += 1
			queue_free()
	
	
	if angle >= maxAngle || angle <= -maxAngle:
		velocity = transform.x * speed * 0.5
	else:
		velocity = transform.x * speed
	
	if Game.plane.velocity:
		rotate(angle)
		move_and_slide()


func _on_timer_timeout() -> void:
	accelerating = 0
	booster.hide()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if !area.get_parent().name == "plane":
		Game.points += 1
	queue_free()
