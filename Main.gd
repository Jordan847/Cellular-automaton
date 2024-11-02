extends Node2D


var cell_scene: PackedScene = preload("res://cell.tscn")

func create_cell(pos: Vector2i, size: int, color: Color):
	var instance = cell_scene.instantiate()
	instance.position = pos
	instance.scale = Vector2i(size, size)
	instance.set_color(color)
	instance.position_in_grid = Vector2i(pos.x/size,pos.y/size)
	$Cells.add_child(instance)


func create_grid():
	if $Cells.get_child_count() != 0:
		destroy_grid()
	
	for y in range(40):
		for x in range(40):
			
			var cell_color
			if randf() > 0.90:
				cell_color = 'white'
			else:
				cell_color = 'black'
			create_cell(Vector2i(x*25,y*25),25,cell_color)

func destroy_grid():
	var cells_to_destroy: Array[Node] = $Cells.get_children()
	for cell in cells_to_destroy:
		cell.queue_free()
	

func get_random_color():
	var random_color = Color(
		randi_range(0, 255) / 255.0,
		randi_range(0, 255) / 255.0,
		randi_range(0, 255) / 255.0
	)
	return random_color

func wrap_grid(position: Vector2i) -> Vector2i:
	position.x = (position.x + 40) % 40
	position.y = (position.y + 40) % 40
	return position


		

func get_cell_position_from_index(index: int) -> Vector2i:
	var y: int = index / 40
	var x: int = index % 40
	return Vector2i(x,y)
	
func get_cell_at_position(position: Vector2i):
		position = wrap_grid(position)
		var cell = $Cells.get_child(40 * position.y + position.x)
		return cell

func check_if_cell_is_white(position: Vector2i) -> int: # this function is mainly for the get_cell_neighbors function
	if get_cell_at_position(position).get_color() == Color.WHITE:
		return 1
	return 0
	
func get_cell_neighbor_count(position: Vector2i) -> Array:
	var sum: int = 0
	for y in range(position.y - 1, position.y + 2):
		for x in range(position.x -1, position.x + 2):
			if x == position.x and y == position.y:
				pass	
			else:
				sum += check_if_cell_is_white(Vector2i(x,y))

	return [sum, 8 - sum] # returns white and black counts

	


func _ready():
	randomize()
	create_grid()

	#print(get_cell_neighbor_count(Vector2(0,0)))
	#for i in range(get_cell_neighbor_count(Vector2(1,1))):
		#get_cell_at_position(Vector2(randi_range(0,39),randi_range(0,39))).set_color(Color.RED)
	
	

#Any live cell with fewer than two live neighbours dies, as if by underpopulation.

#Any live cell with two or three live neighbours lives on to the next generation.

#Any live cell with more than three live neighbours dies, as if by overpopulation.

#Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

func get_next_board_state() -> Array[Color]:
	var next_board: Array[Color]
	var cells: Array[Node] = $Cells.get_children()
	for cell in cells:
		var current_position: Vector2i = cell.position_in_grid
		var live_neighbor_count: int = get_cell_neighbor_count(current_position)[0]
		var cell_color: Color = cell.get_color()

		if cell_color == Color.BLACK: # if cell is dead
			if live_neighbor_count == 3:
				next_board.append(Color.WHITE)
			else:
				next_board.append(cell_color)
		else: #if cell is alive
			if live_neighbor_count < 2:
				next_board.append(Color.BLACK)
			elif live_neighbor_count > 3:
				next_board.append(Color.BLACK)
			else:
				next_board.append(Color.WHITE)
	return next_board


func update_board_state(board) -> void:
	var cells: Array[Node] = $Cells.get_children()
	var i: int = 0
	for cell in cells:
		cell.set_color(board[i])
		i+=1
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
		if $TickRate.is_stopped():
			var board: Array[Color] = get_next_board_state()
			update_board_state(board)
			$TickRate.start()
	
	
	
