extends Node2D


var cell_scene: PackedScene = preload("res://cell.tscn")

func create_cell(pos: Vector2, size: int, color: Color):
	var instance = cell_scene.instantiate()
	instance.position = pos
	instance.scale = Vector2(size, size)
	instance.set_color(color)
	$Cells.add_child(instance)


func create_grid():
	for y in range(40):
		for x in range(40):
			var cell_color
			if randf() > 0.5:
				cell_color = 'white'
			else:
				cell_color = 'black'
			create_cell(Vector2(x*25,y*25),25,cell_color)



func get_random_color():
	var random_color = Color(
		randi_range(0, 255) / 255.0,
		randi_range(0, 255) / 255.0,
		randi_range(0, 255) / 255.0
	)
	return random_color

func get_cell_at_position(position: Vector2):
		var cell = $Cells.get_child(40 * position.y + position.x)
		return cell

func check_if_cell_is_white(position: Vector2) -> int: # this function is mainly for the get_cell_neighbors function
	if get_cell_at_position(position).get_color() == Color.WHITE:
		return 1
	return 0
	
func get_cell_neighbor_count(position: Vector2) -> int:
	var sum: int = 0
	for y in range(position.y - 1, position.y + 1):
		for x in range(position.x -1, position.x + 1):
			if x == position.x and y == position.y:
				print("current cell position")
				pass
			else:
				sum += check_if_cell_is_white(position)
				#print(sum)
	return sum

	


func _ready():
	randomize()
	create_grid()
	#for i in range(get_cell_neighbor_count(Vector2(1,1))):
		#get_cell_at_position(Vector2(randi_range(0,39),randi_range(0,39))).set_color(Color.RED)
	
	

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#var next_board: Array[Color]
	print("hello")
	
	
