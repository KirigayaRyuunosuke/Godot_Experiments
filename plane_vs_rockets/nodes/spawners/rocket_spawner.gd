extends Polygon2D

@onready var marker : Marker2D = $Marker2D
@onready var rocket_spawner: Polygon2D = $"."

func _physics_process(_delta: float) -> void:
	rotation = Game.plane.directionNode.rotation + 3.14
	if Game.main.rockets.get_child_count() == 0:
		spawnRockets(3)

func spawnRockets(howMany):
	rotate(randf_range(-1, 1))
	for i in range(howMany):
		rotate(randf_range(0.25, 0.5))
		var rocket : CharacterBody2D = Game.rockets[randi()%Game.rockets.size()].instantiate()
		rocket.rocketType = [randi()%2,randi()%2]
		rocket.global_position = marker.global_position
		rocket.look_at(Game.plane.global_position)
		Game.main.rockets.add_child(rocket)

func _on_timer_timeout() -> void:
	spawnRockets(1)
