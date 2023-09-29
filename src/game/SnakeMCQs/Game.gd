extends Node


var A_pos
var B_pos
var C_pos
var D_pos
const SNAKE = 0
var snake_body = [Vector2(5,10),Vector2(4,10),Vector2(3,10),Vector2(2,10)]
var snake_direction = Vector2(1,0)
var add_options= false


func _ready():
	A_pos = place_option()
	B_pos = place_option()
	C_pos = place_option()
	D_pos = place_option()
	draw_options()
	draw_snake()

func place_option():
	randomize()
	var x = randi() % 20
	var y = randi() % 20
	return Vector2(x,y)

func draw_options():
	$options.set_cell(0,Vector2(A_pos),0,Vector2(0,0))
	$options.set_cell(0,Vector2(B_pos),1,Vector2(0,0))
	$options.set_cell(0,Vector2(C_pos),2,Vector2(0,0))
	$options.set_cell(0,Vector2(D_pos),3,Vector2(0,0))

func draw_snake():
	for block_index in snake_body.size():
		var block = snake_body[block_index]
		
		if block_index == 0:
			var head_dir = relation2(snake_body[0],snake_body[1])
			if head_dir == 'right': 
				$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(3,1))
			if head_dir == 'left': 
				$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(2,0))
			if head_dir == 'top': 
				$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(3,0))
			if head_dir == 'bottom': 
				$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(2,1))
		elif block_index == snake_body.size() - 1:
			var tail_dir = relation2(snake_body[-1],snake_body[-2])
			if tail_dir == 'right': 
				$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(0,0))
			if tail_dir == 'left': 
				$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(1,0))
			if tail_dir == 'top': 
				$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(1,1))
			if tail_dir == 'bottom': 
				$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(0,1))
		else:
			var previous_block = snake_body[block_index + 1] - block
			var next_block = snake_body[block_index - 1] - block
			
			if previous_block.x == next_block.x:
				$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(4,1))
			elif previous_block.y == next_block.y:
				$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(4,0))
			else:
				if previous_block.x == -1 and next_block.y == -1 or next_block.x == -1 and previous_block.y == -1:
					$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(6,1))
				if previous_block.x == -1 and next_block.y == 1 or next_block.x == -1 and previous_block.y == 1:
					$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(6,0))
				if previous_block.x == 1 and next_block.y == -1 or next_block.x == 1 and previous_block.y == -1:
					$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(5,1))
				if previous_block.x == 1 and next_block.y == 1 or next_block.x == 1 and previous_block.y == 1:
					$SnakeApple.set_cell(0,Vector2(block.x,block.y),SNAKE,Vector2(5,0))

func relation2(first_block:Vector2,second_block:Vector2):
	var block_relation = second_block - first_block
	if block_relation == Vector2(-1,0): return 'left'
	if block_relation == Vector2(1,0): return 'right'
	if block_relation == Vector2(0,1): return 'bottom'
	if block_relation == Vector2(0,-1): return 'top'

func move_snake():
	if add_options:
		var body_copy = snake_body.slice(0,snake_body.size())
		var new_head = body_copy[0] + snake_direction
		body_copy.insert(0,new_head)
		snake_body = body_copy
		add_options = false
		delete_tiles(SNAKE)
	else:
		var body_copy = snake_body.slice(0,snake_body.size() - 1)
		var new_head = body_copy[0] + snake_direction
		body_copy.insert(0,new_head)
		snake_body = body_copy
		delete_tiles(SNAKE)

func delete_tiles(id:int):
	var cells = $SnakeApple.get_used_cells_by_id(id)
	for cell in cells:
		$SnakeApple.set_cell(0,Vector2(cell.x,cell.y),-1)

func _input(event):
	if Input.is_action_just_pressed("ui_up"): 
		if not snake_direction == Vector2(0,1):
			snake_direction = Vector2(0,-1)
	if Input.is_action_just_pressed("ui_right"): 
		if not snake_direction == Vector2(-1,0):
			snake_direction = Vector2(1,0)
	if Input.is_action_just_pressed("ui_left"): 
		if not snake_direction == Vector2(1,0):
			snake_direction = Vector2(-1,0)
	if Input.is_action_just_pressed("ui_down"): 
		if not snake_direction == Vector2(0,-1):
			snake_direction = Vector2(0,1)

func check_game_over():
	var head = snake_body[0]
	# snake leaves the screen
	if head.x > 20 or head.x < 0 or head.y < 0 or head.y > 20:
		reset()
	
	# snake bites its own tail
	for block in snake_body.slice(1,snake_body.size() - 1):
		if block == head:
			reset()
			get_tree().quit()

func reset():
	snake_body = [Vector2(5,10),Vector2(4,10),Vector2(3,10)]
	snake_direction = Vector2(1,0)

func check_selected_option():
	if (snake_body[0]==A_pos || snake_body[0]==B_pos || snake_body[0]==C_pos || snake_body[0]==D_pos):
		del_options()
		A_pos=place_option()
		B_pos=place_option()
		C_pos=place_option()
		D_pos=place_option()
		add_options=true

func del_options():
	var opts= $options.get_used_cells(0)
	for cell in opts:
		$options.set_cell(0,Vector2(cell.x,cell.y),-1)

func _on_snaketick_timeout():
	move_snake()
	draw_options()
	draw_snake()
	check_selected_option()

func _process(delta):
	check_game_over()
