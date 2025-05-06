extends Polygon2D

@onready var marker = $Marker2D
@onready var rocket_spawner: Polygon2D = $"."

var rockets = [
	#preload("res://nodes/rockets/blue_blue/rocket.tscn"),
	preload("res://nodes/rockets/red_blue/rocket.tscn"),
	preload("res://nodes/rockets/blue_red/rocket.tscn"),
	preload("res://nodes/rockets/red_red/rocket.tscn"),
]
var rocketTest = preload("res://nodes/rockets/blue_blue/rocket.gd")
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	rotation = Game.plane.directionNode.rotation + 3.14

func spawnRockets(howMany):
	for i in range(howMany):
		rotate(randf_range(-1, 1))
		print(marker.global_position)
		var rocket = rockets[randi()%rockets.size()].instantiate()
		rocket.global_position = marker.global_position
		rocket.look_at(Game.plane.global_position)
		Game.main.add_child(rocket)

func _on_timer_timeout() -> void:
	spawnRockets(3)
