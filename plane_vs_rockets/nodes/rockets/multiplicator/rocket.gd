extends CharacterBody2D

@onready var explosion: Node2D = $explosion

@onready var body: Polygon2D = $body
@onready var tip: Polygon2D = $tip
@onready var stripe: Polygon2D = $stripe

@onready var booster: Polygon2D = $booster
@onready var timer: Timer = $Timer

var normalRocket = preload("res://nodes/rockets/normal/rocket.tscn")

var score := 3

var angle : float
var maxAngle := 0.025
var speed := 250.0

var acceleration := 5
var deacceleration := 3
var accelerating: bool = 1

var rocketType := [0,0]

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
		multiplicate()
			
	
	
	if angle >= maxAngle || angle <= -maxAngle:
		velocity = transform.x * speed * 0.5
	else:
		velocity = transform.x * speed
	
	if Game.plane.velocity:
		rotate(angle)
		move_and_slide()

func multiplicate():
	for i in range(3):
		var rocket := normalRocket.instantiate()
		rocket.global_position = global_position - transform.x * 50 * i
		rocket.rocketType = [1,0]
		rocket.rotation = rotation
		rocket.scale *= 0.33
		rocket.speed = speed
		rocket.maxAngle = 0.05
		rocket.score = 1
		Game.main.add_child(rocket)
	queue_free()

func _on_timer_timeout() -> void:
	accelerating = 0
	booster.hide()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if !area.get_parent().name == "plane" && !area.get_parent().is_in_group("powerups"):
		Game.points += score
		explode()

func explode():
	timer.stop()
	speed = 0
	velocity = Vector2.ZERO
	body.hide()
	explosion.show()
	if explosion.timer.is_stopped():
		explosion.timer.start()
