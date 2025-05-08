extends Node2D

func _physics_process(_delta: float) -> void:
	if scale < Vector2(1,1):
		scale += Vector2(0.1,0.1)
	if scale > Vector2(1,1): scale = Vector2(1,1)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "plane":
		Game.plane.haveShield = 1
		queue_free()
