extends TileMap

var cell_class = preload("res://scripts/map/Cell.gd")
onready var highlight = get_node("HoverCellHighlight")
var current_cell = Vector2(0,0)
var grid_size = Vector2(0,0)
var cells = {} # Dictionary of cells: key - Vector2 location on map, value - instance of cell class

func _ready():
	grid_size = get_used_cells().back()
	highlight.set_visible(false)
	initialise_cells()

func _process(_delta):
	var mouse_position = get_global_mouse_position()
	var temp = world_to_map(mouse_position)
	if current_cell != temp:
		current_cell = temp
		if cell_in_map(current_cell):
			hightlight_cell(highlight, current_cell)
		else:
			disable_highlight()
		
func cell_in_map(cell):
	return cell.x >= 0 and cell.x <= grid_size.x and cell.y >= 0 and cell.y <= grid_size.y
		
func disable_highlight():
	highlight.set_visible(false)

func hightlight_cell(highlight_type, cell):
	var target_pos = map_to_world_fixed(cell)
	highlight_type.global_position = target_pos
	highlight_type.set_visible(true)

func map_to_world_fixed(coords):
	print(cell_size)
	return map_to_world(coords, false) + (cell_size / 2)
	
func distance(cell1, cell2):
	return map_to_world_fixed(cell1).distance_to(map_to_world_fixed(cell2))
	
func distance_squared(cell1, cell2):
	return map_to_world_fixed(cell1).distance_squared_to(map_to_world_fixed(cell2))

func initialise_cells():
	for x in range(0, grid_size.x + 1):
		for y in range(0, grid_size.y + 1):
			var cell = cell_class.Cell.new("Grass", Vector2(x, y))
			cells[Vector2(x, y)] = cell

func get_movement_path(start, end):
	return a_star(start, end)
	
func a_star(start, end):
	var open_list = []
	var closed_list = []
	var path = []
	
	var first = cells[start]
	first.g = 0
	first.h = 0
	first.f = 0
	open_list.append(first)
	
	var iterations = 0
	
	while not open_list.empty():
		iterations += 1
		open_list.sort_custom(cell_class.Cell, "sort_ascending")
		var current = open_list.pop_front()
		closed_list.append(current)
		if current.position == end:
			return closed_list
		var neighbours = get_neighbours(current, end)
		for n in neighbours:
			var ignore = false
			for i in range(0, open_list.size()):
				if n.position == open_list[i].position:
					if open_list[i].g <= n.g:
						ignore = true
			for j in range(0, closed_list.size()):
				if n.position == closed_list[j].position:
					ignore = true
			if not ignore:
				open_list.append(n)
	
	var temp = closed_list.back()
	if temp.position != end:
		return []
		
	while temp.position != start.position:
		path.push_front(temp)
		temp = temp.parent
	return path
		
func get_neighbours(current, end):
	var neighbours = []
	for i in range(-1, 2):
		for j in range(-1, 2):
			var cell = Vector2(i, j) + current.position
			var dist = distance(cell, current.position)
			if dist <= 128:
				if cell_in_map(cell) and cell != current.position:
					var neighbour = cells[cell]
					neighbour.parent = current
					neighbour.g = current.g + dist
					neighbour.h = distance_squared(cell, end)
					neighbour.f = neighbour.g + neighbour.h
					neighbours.append(neighbour)
	return neighbours

