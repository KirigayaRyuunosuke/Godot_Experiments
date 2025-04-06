extends Node2D

@onready var down: CollisionShape2D = $borders/down
@onready var right: CollisionShape2D = $borders/right

var segmentBackground = preload("res://nodes/level_segment_0.tscn")

var segmentPreload
var drawingPosition = Vector2(0,0)

@onready var map: Node2D = $map

func _ready() -> void:
	
	var colls = 10
	var rows = 10
	var result = []
	
	down.global_position.y = rows * 100
	right.global_position.x = colls * 100
	
	for a in range(rows):
		result.append([])
		for i in range(colls):
			result[a].append(randi() % 2)
		#print(str(result[a]))
		
	_clearSingles(result,colls,rows)
	_connectRest(result,colls,rows)
	_drawMap(result,colls,rows)

func _clearSingles(array,colls,rows):
	for a in range(rows):
		for i in range(colls):
			var checked : int = 0
			var nulls : int = 0
			if array[a][i] == 1 :
				if a - 1 >= 0 && array[a-1][i] == 0:
					nulls += 1
					checked += 1
				elif a - 1 >= 0 && array[a-1][i] == 1:
					checked += 1
				if a + 1 < rows && array[a+1][i] == 0:
					nulls += 1
					checked += 1
				elif a + 1 < rows && array[a+1][i] == 1:
					checked += 1
				if i - 1 >= 0 && array[a][i-1] == 0:
					nulls += 1
					checked += 1
				elif i - 1 >= 0 && array[a][i-1] == 1:
					checked += 1
				if i + 1 < colls && array[a][i+1] == 0:
					nulls += 1
					checked += 1
				elif i + 1 < colls && array[a][i+1] == 1:
					checked += 1
				if nulls == checked:
					array[a][i] = 0

func _mapZones(array,colls,rows):
	var groups = 1
	var result = []
	for a in range(rows):
		result.append([])
		for i in range(colls):
			if array[a][i] == 1:
				if a - 1 >= 0 && (result[a-1][i]) >= 2:
					result[a].append(result[a-1][i])
				elif i - 1 >= 0 && (result[a][i-1]) >= 2:
					result[a].append(result[a][i-1])
				else:
					groups += 1
					result[a].append(groups)
			else:
				result[a].append(0)
	return result

func _connectZones(array,colls,rows):
	var connected = []
	for a in range(rows):
		connected.append([])
		for i in range(colls):
			if array[a][i] != 0:
				connected[a].append(1)
			else:
				connected[a].append(0)
		print(str(connected[a]))
	return connected

func _connectRest(array,colls,rows):
	_connectZones(_mapZones(array,colls,rows),colls,rows)

func _drawMap(array,colls,rows):
	for a in range(rows):
		for i in range(colls):
			drawingPosition = Vector2(i*100,a*100)
			if array[a][i] == 1:
				var segment = segmentBackground.instantiate()
				segment.global_position = drawingPosition
				map.add_child(segment)
