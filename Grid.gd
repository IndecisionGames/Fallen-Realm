extends TileMap

onready var highlight = get_node("CellHighlight")
var current_cell = Vector2(0,0)
var grid_size = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	grid_size = get_used_cells().back()
	highlight.set_visible(false)



func _process(delta):
	var mouse_position = get_global_mouse_position()
	var temp = world_to_map(mouse_position)
	if current_cell != temp:
		current_cell = temp
		if cell_in_map(current_cell):
			enable_highlight(current_cell)
		else:
			disable_highlight()
		
		
func cell_in_map(cell):
	return cell.x >= 0 and cell.x <= grid_size.x and cell.y >= 0 and cell.y <= grid_size.y
	
func enable_highlight(cell):
	var target_pos = map_to_world(cell, true) + (cell_size / 2)
	highlight.global_position = target_pos
	highlight.set_visible(true)
	
func disable_highlight():
	highlight.set_visible(false)
