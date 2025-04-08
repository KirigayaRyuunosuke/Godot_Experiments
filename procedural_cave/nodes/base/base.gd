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
	
	var cols = 20
	var rows = 20
	var halls = 15
	
	down.global_position.y = rows * 100
	right.global_position.x = cols * 100

	_drawMap(_mapGenerator(rows,cols))

func _mapGenerator(rows,cols):
	var result = []
	result = _randomPointsGenerator(rows,cols)
	result = _clear(result)
	
	for a in range(result.size()):
		print(result[a])
	
	return result

func _randomPointsGenerator(rangeX,rangeY):
	var result = []
	for a in range(rangeX):
		result.append([])
		for i in range(rangeY):
			result[a].append(randi() % 2)
	return result

func _clear(array):
	var result = array
	
	result = _mapZones(result)
	result = _connectZones(result)
	result = _remapZones(result)
	
	var zonesCounter = []
	for i in range(_findBiggestZone(result)+1):
		zonesCounter.append(0)
	for a in range(result.size()):
		for i in range(result[a].size()):
			if result[a][i] > 0:
				zonesCounter[result[a][i]] += 1
	for i in range(zonesCounter.size()):
		if zonesCounter[i] < 10 || zonesCounter[i] > 30:
			result = _removeZone(result,i)
	result = _remapZones(result)
	return result

func _removeZone(array,zone):
	return _changeValuesInArray(array,zone,0)

func _findBiggestZone(array):
	var result = 0
	for a in range(array.size()):
		for i in range(array[a].size()):
			if array[a][i] > result:
				result = array[a][i]
	return result

func _mapZones(array):
	var groups = 1
	var result = array
	for a in range(result.size()):
		for i in range(result[a].size()):
			if array[a][i] == 1 :
				if a - 1 >= 0 && result[a-1][i] > 1:				# up
					result[a][i] = result[a-1][i]
				elif a + 1 < result.size() && result[a+1][i] > 1:		# down
					result[a][i] = result[a+1][i]
				elif  i - 1 >= 0 && result[a][i-1] > 1:				# left
					result[a][i] = result[a][i-1]
				elif i + 1 < result[a].size() && result[a][i+1] > 1:	# right
					result[a][i] = result[a][i+1]
				else:
					groups += 1
					result[a][i] = groups
	return result

func _connectZones(array):
	var result = array
	for a in range(result.size()):
		for i in range(result[a].size()):
			if result[a][i] > 0:
				if a - 1 >= 0 && result[a-1][i] > 1:				# up
					result = _changeValuesInArray(result,result[a-1][i],result[a][i])
				if a + 1 < result.size() && result[a+1][i] > 1:		# down
					result = _changeValuesInArray(result,result[a+1][i],result[a][i])
				if  i - 1 >= 0 && result[a][i-1] > 1:				# left
					result = _changeValuesInArray(result,result[a][i-1],result[a][i])
				if i + 1 < result[a].size() && result[a][i+1] > 1:	# right
					result = _changeValuesInArray(result,result[a][i+1],result[a][i])
	return result

func _remapZones(array):
	var result = array
	var newValue = []
	var isIn : bool = 0
	for a in range(result.size()):
		for i in range(result[a].size()):
			isIn = 0
			if result[a][i] > 0:
				if newValue.size() == 0:
					newValue.append(result[a][i])
				for c in range(newValue.size()):
					if newValue[c] == result[a][i]:
						isIn = 1
				if !isIn:
					newValue.append(result[a][i])
	for i in range(newValue.size()):
		result = _changeValuesInArray(result,newValue[i],i+1)
	return result

func _changeValuesInArray(array,from,to):
	var result = array
	for a in range(result.size()):
		for i in range(result[a].size()):
			if result[a][i] == from:
				result[a][i] = to
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

func _drawMap(array):
	for a in range(array.size()):
		for i in range(array[a].size()):
			drawingPosition = Vector2(i*100,a*100)
			if array[a][i] > 0:
				var segment = segmentFloor.instantiate()
				segment.global_position = drawingPosition
				mapNode.add_child(segment)
			else:
				var segment = segmentWall.instantiate()
				segment.global_position = drawingPosition
				mapNode.add_child(segment)
