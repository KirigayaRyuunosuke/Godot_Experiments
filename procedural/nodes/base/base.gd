extends Node2D

@onready var down: CollisionShape2D = $borders/down
@onready var right: CollisionShape2D = $borders/right
@onready var map: Node2D = $map

var segmentBackground = preload("res://nodes/level_segment_0.tscn")

var segmentPreload
var drawingPosition = Vector2(0,0)

func _ready() -> void:
	
	var cols = 20
	var rows = 20
	var halls = 4
	
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
	result = _drawHalls(points,rows,cols)
	result = _drawRoads(points,result)
	return result

func _drawHalls(points,rows,cols):
	var result = []
	for a in range(rows):
		result.append([])
		for i in range(cols):
			result[a].append(0)
	for i in range(points.size()):
		for x in range(3):
			for y in range(3):
				result[points[i][0]+x][points[i][1]+y] = 1
	return result

func _randomPointsGenerator(rangeX,rangeY,howMany):
	var points = []
	var x = rangeX - 2
	var y = rangeY - 2
	points.append([randi()%x,randi()%y])
	var i = 0
	var tries = 0
	while i < howMany-1 && tries < 100:
		tries += 1
		var newX = randi()%x
		var newY = randi()%y
		if _checkAvailability(points,[newX,newY]):
			points.append([newX,newY])
			i += 1
	return points

func _checkAvailability(points,newPoint):
	var distanceX
	var distanceY
	var minimalDistanceBetween = 5
	var maximumDistanceBetween = 10
	for i in range(points.size()):
		distanceX = points[i][0] - newPoint[0]
		distanceY = points[i][1] - newPoint[1]
		if distanceX < 0: distanceX *= -1
		if distanceY < 0: distanceY *= -1
		if distanceX < minimalDistanceBetween && distanceY < minimalDistanceBetween:
			return 0
	distanceX = points[points.size()-1][0] - newPoint[0]
	distanceY = points[points.size()-1][1] - newPoint[1]
	if distanceX < 0: distanceX *= -1
	if distanceY < 0: distanceY *= -1
	if distanceX < maximumDistanceBetween && distanceY < maximumDistanceBetween:
		return 1
	return 0

func _drawRoads(points,map):
	var centerPoints = []
	for x in range(points.size()):
		centerPoints.append([])
		for y in range(points[x].size()):
			centerPoints[x].append(points[x][y]+1)
	var result = []
	
	return result

func _drawMap(array):
	for a in range(array.size()):
		for i in range(array[a].size()):
			drawingPosition = Vector2(i*100,a*100)
			if array[a][i] == 1:
				var segment = segmentBackground.instantiate()
				segment.global_position = drawingPosition
				map.add_child(segment)
