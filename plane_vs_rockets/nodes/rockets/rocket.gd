extends CharacterBody2D

@onready var body: Polygon2D = $body
@onready var tip: Polygon2D = $tip
@onready var stripe: Polygon2D = $stripe

@onready var booster: Polygon2D = $booster
@onready var timer: Timer = $Timer

var angle
const maxAngle = 0.025
var speed = 250

var acceleration = 5
var deacceleration = 3
var accelerating: bool = 1

var rocketType = [0,0]

func _ready() -> void:
	if rocketType[0] == 0:
		tip.color = Color(255,0,0)
	else:
		tip.color = Color(0,0,255)
	if rocketType[1] == 1:
		stripe.color = Color(255,0,0)
	else:
		stripe.color = Color(0,0,255)
	acceleration = 5 + rocketType[0] * 2
	deacceleration = 3 - rocketType[1] * 2

func _physics_process(_delta: float) -> void:
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
