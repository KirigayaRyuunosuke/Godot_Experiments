# Procedural level generator for godot4.4
## My target
I wanted to create simple procedural cave generator to use in my godots project.
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
