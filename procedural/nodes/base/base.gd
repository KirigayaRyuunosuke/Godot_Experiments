extends Node2D

var begining = preload("res://nodes/level_segment_0.tscn").instantiate()
var ending = preload("res://nodes/level_segment_end.tscn").instantiate()

var segmentPreload
var drawingPosition = Vector2(0,0)

@onready var map: Node2D = $map

func _ready() -> void:
	segmentPreload = preload("res://nodes/level_segment_0.tscn")
	var segment = segmentPreload.instantiate()
	segment.global_position = drawingPosition
	map.add_child(begining)
	drawingPosition += Vector2(100,0) 
	ending.global_position = drawingPosition
	map.add_child(ending)
	
	var colls = 10
	var rows = 10
	var result = []
	
	for a in range(rows):
		result.append([])
		for i in range(colls):
			result[a].append(randi() % 2)
		print(str(result[a]))
