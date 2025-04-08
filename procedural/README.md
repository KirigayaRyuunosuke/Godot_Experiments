# Procedural level generator for godot4.4
## My target
I wanted to create simple procedural level generator to use in my godots project.
## No AI code
I sometimes asked AI why something doesn't work, because my debugging skills are pretty basic, but i didn't copied single line of code from it. I wanted to make it clear, why this code looks like shit ;D
## How does it work?
I am using two dimensional array which is defined on the beginning of my **_ready()** function by variables cols and rows.
My generator uses predefined number of halls stored in halls variable.
``` gdscript
func _ready() -> void:

	var cols = 20
	var rows = 20
	var halls = 10
```
After that i set world borders:
``` gdscript
down.global_position.y = rows * 100
right.global_position.x = cols * 100
```
And then BOOM! Magic:

``` gdscript
_drawMap(_mapGenerator(rows,cols,halls))
```
And basically thats it, but now, let's get serious
## _mapGenerator
This function could be in _ready(), but i wanted to keep all my functions in one place
```gdscript
func _mapGenerator(rows,cols,halls):
	var result = []
	var points = []
	points = _randomPointsGenerator(rows,cols,halls)
	result = _drawHalls(points,rows,cols)
	result = _drawRoads(points,result)
	return result
```
Two variables at the beginning are used to store location of halls (*points*) and the final *result*
## _randomPointsGenerator
This function generates positions for my halls using **randi()** function.
```gdscript
func _randomPointsGenerator(rangeX,rangeY,howMany):
	var points = []
	var x = (rangeX-(rangeX%3))/3
	var y = (rangeY-(rangeY%3))/3
	points.append([(randi()%x)*3,(randi()%y)*3])
	var i = 0
	var tries = 0
	while i < howMany-1 && tries < 100:
		tries += 1
		var newX = (randi()%x)*3
		var newY = (randi()%y)*3
		if _checkAvailability(points,[newX,newY]):
			points.append([newX,newY])
			i += 1
	return points
```
### Update:
Added small changes to generate halls on grade to avoid collapsing corridors
```gdscript
var x = (rangeX-(rangeX%3))/3
var newX = (randi()%x)*3
```
I wished my halls not to collide with each other, so I created function, which sets minimal, and maximum distances between each halls
```gdscript
func _checkAvailability(points,newPoint):
	var distanceX
	var distanceY
	var minimalDistanceBetween = 4
	var maximumDistanceBetween = 100
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
```
## _drawHalls
This function is used to generate array for the first time and then apply first changes into it. I used two for every time, what is easier to work with, even if it adds some nesting into my code
```gdscript
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
```
## _drawRoads
Last step to complete map is connecting halls, which was, in fact, harder than I expected, but finally, accomplished
```gdscript
func _drawRoads(points,map):
	var result = map
	var centerPoints = []
	for x in range(points.size()):
		centerPoints.append([])
		for y in range(points[x].size()):
			centerPoints[x].append(points[x][y]+1)
		print(str(centerPoints))
	for i in range(centerPoints.size()-1):
		result = _drawLine(centerPoints[i],centerPoints[i+1],result)
	return result
```
First, calculate center of each hall, then pass center of one hall and center of next one to **_drawLine()** function:
```gdscript
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
```
This may seems odd at the first glance, and it is. Mostly because i switch X and Y places like 2 times in that function, but it was easier for me to accomplish it this way. Now I can remove aX, aY and rest variables and just paste pointX[Y] in their place, but I wont do this, because of readability of my code
## _drawMap
When level is finally created we have to *print* it
```gdscript
func _drawMap(array):
	for a in range(array.size()):
		for i in range(array[a].size()):
			drawingPosition = Vector2(i*100,a*100)
			if array[a][i] == 1:
				var segment = segmentBackground.instantiate()
				segment.global_position = drawingPosition
				mapNode.add_child(segment)

```
Classic double for, I used 100x100 segments, preloaded at the beginning of my code
