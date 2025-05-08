extends Polygon2D

@onready var marker : Marker2D = $Marker2D
@onready var rocket_spawner: Polygon2D = $"."

func _ready() -> void:
	pass#_addBooster()

func _physics_process(_delta: float) -> void:
	rotation = Game.plane.directionNode.rotation

func _addBooster():
	rotate(randf_range(-3.14, 3.14))
	var booster = Game.powerups[randi() % Game.powerups.size()].instantiate()
	booster.global_position = marker.global_position
	Game.main.boosters.add_child(booster)

func _on_timer_timeout() -> void:
	_addBooster()
