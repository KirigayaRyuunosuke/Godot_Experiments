extends Polygon2D

@onready var marker = $Marker2D
@onready var rocket_spawner: Polygon2D = $"."

var rockets = preload("res://nodes/rockets/rocket.tscn")

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	rotation = Game.plane.directionNode.rotation + 3.14

func spawnRockets(howMany):
	rotate(randf_range(-1, 1))
	for i in range(howMany):
		rotate(randf_range(0.25, 0.5))
		#print(marker.global_position)
		var rocket = rockets.instantiate()
		rocket.rocketType = [randi()%2,randi()%2]
		rocket.global_position = marker.global_position
		rocket.look_at(Game.plane.global_position)
		Game.main.add_child(rocket)

func _on_timer_timeout() -> void:
	spawnRockets(3)
