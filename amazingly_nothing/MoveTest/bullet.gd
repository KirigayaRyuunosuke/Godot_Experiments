extends CharacterBody2D

var speed = 300

func _on_tree_entered() -> void:
	look_at(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	velocity = transform.x * speed
	move_and_slide()
