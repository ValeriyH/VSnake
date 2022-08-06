extends Node2D

const EMPTY = -1
const SNAKE = 0
const LETTER_A = 1
const LETTER_Z = 26

const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

var snake_direction : Vector2 = RIGHT
var snake = []

# Called when the node enters the scene tree for the first time.
func _ready():
	snake_init()
	place_letter()
	
func _input(_event):
	if Input.is_action_pressed("ui_left"):
		snake_direction = Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		snake_direction = Vector2(1, 0)
	if Input.is_action_pressed("ui_up"):
		snake_direction = Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		snake_direction = Vector2(0, 1)
	
func snake_init():
	for i in range(3):
		snake.push_front(Vector2(i,0))
	for i in range(snake.size()):
		place_snake(i)
	
	#Set timer interval to move snake faster or slower
	$SnakeTimer.start()

func place_letter():
	var placed = false
	randomize()
	while(!placed):
		var x = randi() % 20
		var y = randi() % 20
		var letter = randi() % 26 + LETTER_A
		if ($TileMap.get_cell(x, y) == EMPTY):
			$TileMap.set_cell(x, y, letter)
			placed = true

func place_snake(var index:int):
	var position = snake[index]
	var image = get_snake_image(index)
	$TileMap.set_cellv(position, SNAKE, false, false, false, image)

# Returns image id from snake spreadsheet
func get_snake_image(var index : int) -> Vector2:
	
	# Head
	if (index == 0) :
		if snake_direction == LEFT:
			return Vector2(3, 1)
		if snake_direction == RIGHT:
			return Vector2(2, 0)
		if snake_direction == UP:
			return Vector2(2, 1)
		if snake_direction == DOWN:
			return Vector2(3, 0)
		return Vector2(7, 0)
	
	# Tail
	if (index == snake.size() -1):
		var tail = snake[-1]
		var prev = snake[-2]
		var direction = tail - prev
		if direction == LEFT:
			return Vector2(0, 0)
		if direction == RIGHT:
			return Vector2(1, 0)
		if direction == UP:
			return Vector2(0, 1)
		if direction == DOWN:
			return Vector2(1, 1)
		return Vector2(7, 0)
		
	# Body
	var dir1 = snake[index] - snake[index-1]
	var dir2 = snake[index+1] - snake[index]
	var dir = [dir1, dir2]
	
	if dir in [[LEFT, LEFT],[RIGHT, RIGHT]]:
		# horizontal
		return Vector2(4, 0)
	if dir in [[UP,UP],[DOWN,DOWN]]:
		# vertical
		return Vector2(4, 1)
	if dir in [[UP,RIGHT],[LEFT,DOWN]]:
		return Vector2(5,0)
	if dir in [[DOWN,RIGHT],[LEFT,UP]]:
		return Vector2(5,1)
	if dir in [[RIGHT,DOWN],[UP,LEFT]]:
		return Vector2(6,0)
	if dir in [[RIGHT, UP],[DOWN,LEFT]]:
		return Vector2(6,1)
	
	# undefined	
	return Vector2(7, 0)

func update_snake():
	var grow = false
	var head = snake[0]
	head += snake_direction
	var object = $TileMap.get_cellv(head)
	if  object >= LETTER_A and object <= LETTER_Z:
		place_letter()
		grow = true
	snake.push_front(head)
	place_snake(0)
	place_snake(1)
	if !grow:
		var tail = snake.pop_back()
		$TileMap.set_cellv(tail, EMPTY)
		place_snake(snake.size()-1)
	
	#TODO: use twin for head and tail for more smooth moving
	# See sample https://kidscancode.org/godot_recipes/2d/grid_movement/
	#create_tween()

func _on_SnakeTimer():
	update_snake()
	pass
