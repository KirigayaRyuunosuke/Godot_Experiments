extends Node2D

@onready var down: CollisionShape2D = $borders/down
@onready var right: CollisionShape2D = $borders/right
@onready var map: Node2D = $map

var segmentBackground = preload("res://nodes/level_segment_0.tscn")

var segmentPreload
var drawingPosition = Vector2(0,0)

func _ready() -> void:
	
	var cols = 10
	var rows = 10
	var halls = 3
	
	down.global_position.y = rows * 100
	right.global_position.x = cols * 100
	
	# var result = []
	# result = _mapGenerator(rows,cols,halls)
	# _drawMap(result)
	
	_drawMap(_mapGenerator(rows,cols,halls))

func _mapGenerator(rows,cols,halls):
	var result = []
	var points = []
	points = _randomPointsGenerator(rows,cols,halls)
	result = _drawPoints(points,halls,rows,cols)
	return result

func _drawPoints(points,howMany,rows,cols):
	var result = []
	for a in range(rows):
		result.append([])
		for i in range(cols):
			result[a].append(0)
		print(str(result[a]))
	for i in range(howMany):
		result[points[i][0]][points[i][1]] = 1
	return result

func _randomPointsGenerator(rangeX,rangeY,howMany):
	var points = []
	points.append([randi()%rangeX,randi()%rangeY])
	for i in range(howMany-1): 
		points.append([randi()%rangeX,randi()%rangeY])
	return points

func _drawMap(array):
	for a in range(array.size()):
		for i in range(array[a].size()):
			drawingPosition = Vector2(i*100,a*100)
			if array[a][i] == 1:
				var segment = segmentBackground.instantiate()
				segment.global_position = drawingPosition
				map.add_child(segment)
