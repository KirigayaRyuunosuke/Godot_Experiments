extends Node2D

@onready var timer: Timer = $Timer

func _on_timer_timeout() -> void:
	get_parent().queue_free()
