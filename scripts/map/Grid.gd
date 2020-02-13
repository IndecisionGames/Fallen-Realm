extends TileMap

onready var highlight = get_node("CellHighlight")
var current_cell = Vector2(0,0)
var grid_size = Vector2(0,0)

func _ready():
	grid_size = get_used_cells().back()
	highlight.set_visible(false)

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
	return map_to_world(coords, true) + (cell_size / 2)
