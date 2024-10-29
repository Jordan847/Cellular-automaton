extends Node2D


var cell_scene: PackedScene = preload("res://cell.tscn")

func create_cell(pos: Vector2, size: int, color: Color):
	var instance = cell_scene.instantiate()
	instance.position = pos
	instance.scale = Vector2(size, size)
	instance.set_color(color)
	$Cells.add_child(instance)


func create_grid():
	for l in range(40):
		for w in range(40):
			var cell_color
			if randf() > 0.5:
				cell_color = 'white'
			else:
				cell_color = 'black'
			create_cell(Vector2(w*25,l*25),25,cell_color)
		
		
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



func print_children():
	var w : int
	var b : int
	for i in range($Cells.get_child_count()):
		var cell = $Cells.get_child(i)
		
		
		
		if cell.get_color() == Color.WHITE:
			w+=1
		else:
			b+=1
		
	
		
	

func _ready():
	randomize()
	create_grid()
	
	

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_cell_at_position(Vector2(randi_range(0,39), randi_range(0,39))).set_color(get_random_color())

	
