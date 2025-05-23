extends Node2D

@onready var player: CharacterBody2D = $player

@onready var down: CollisionShape2D = $borders/down
@onready var right: CollisionShape2D = $borders/right
@onready var mapNode: Node2D = $map

var segmentFloor = preload("res://nodes/level_segment_0.tscn")
var segmentWall = preload("res://nodes/level_segment_1.tscn")

var drawingPosition = Vector2(0,0)
var playerStartingPosition : Vector2

func _ready() -> void:
	var tileSize = 50
	var cols = 40
	var rows = 40
	var halls = 15
	
	down.global_position.y = rows * tileSize
	right.global_position.x = cols * tileSize

	_drawMap(_mapGenerator(rows,cols,halls),tileSize)
	player.global_position = (playerStartingPosition*tileSize) + Vector2(35,35)

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
				result[points[i][0]+y][points[i][1]+x] = 1
	return result

func _randomPointsGenerator(rangeX,rangeY,howMany):
	var points = []
	var x = (rangeX-(rangeX%3))/3
	var y = (rangeY-(rangeY%3))/3
	var newX = (randi()%x)*3
	var newY = (randi()%y)*3
	points.append([newX,newY])
	var i = 0
	var tries = 0
	while i < howMany-1 && tries < 2500:
		tries += 1
		newX = (randi()%x)*3
		newY = (randi()%y)*3
		if _checkAvailability(points,[newX,newY]):
			points.append([newX,newY])
			i += 1
	return points

func _checkAvailability(points,newPoint):
	var distanceX
	var distanceY
	var minimalDistanceBetween = 4
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
	var result = map
	var centerPoints = []
	for x in range(points.size()):
		centerPoints.append([])
		for y in range(points[x].size()):
			centerPoints[x].append(points[x][y]+1)
	for i in range(centerPoints.size()-1):
		result = _drawLine(centerPoints[i],centerPoints[i+1],result)
	playerStartingPosition = Vector2(centerPoints[0][1],centerPoints[0][0])
	return result

func _drawLine(pointA,pointB,array):
	var result = array
	var aX = pointA[1]
	var aY = pointA[0]
	var bX = pointB[1]
	var bY = pointB[0]
	if aX > bX:
		for x in range(aX-bX+1):
			result[aY][aX - x] = 1
	else:
		for x in range(bX-aX+1): 
			result[aY][aX + x] = 1
	
	if aY > bY:
		for y in range(aY-bY+1):
			result[aY - y][bX] = 1
	else:
		for y in range(bY-aY+1): 
			result[aY + y][bX] = 1
	
	return result

func _drawMap(array,tileSize):
	for a in range(array.size()):
		for i in range(array[a].size()):
			drawingPosition = Vector2(i*tileSize,a*tileSize)
			if array[a][i] > 0:
				var segment = segmentFloor.instantiate()
				segment.global_position = drawingPosition
				mapNode.add_child(segment)
			else:
				var segment = segmentWall.instantiate()
				segment.global_position = drawingPosition
				mapNode.add_child(segment)
