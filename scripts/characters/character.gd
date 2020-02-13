extends Node2D

var green_cell = preload("res://map/CellHighlight.tscn")

var selected = false
var movement = 2
var current_position;
var target_position;
var under_mouse = false;
var highlighted_cells = [];
var global_cancel_origin = false

onready var Grid = get_node("/root/Game/Map/Grid")

func _ready():
	add_to_group("characters")
	current_position = Grid.world_to_map(global_position)
	
func select():
	print("selected")
	selected = true
	global_cancel_origin = true
	get_tree().call_group("characters", "cancel")
	highlight_reachable_cells()

func cancel():
	if not global_cancel_origin:
		print("cancelled")
		for n in highlighted_cells:
			n.queue_free()
		highlighted_cells.clear()
		selected = false
	global_cancel_origin = false
	
func act():
	print("acted")
	# do nothing if not clicked in valid (green) cell
	# do something if clicked on valid cell (e.g. move to that cell)

func _on_SelectZone_mouse_entered():
	under_mouse = true


func _on_SelectZone_mouse_exited():
	under_mouse = false

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			if under_mouse and not selected:
				select()
			elif selected and not under_mouse:
				cancel()
		if event.button_index == BUTTON_RIGHT:
			if selected and not under_mouse:
				target_position = Grid.world_to_map(get_global_mouse_position())
				act()

func highlight_reachable_cells():
	for i in range(-movement, movement+1):
		for j in range(-movement, movement+1):
			if abs(i) + abs(j) <= movement:
				var cell = Vector2(i, j) + current_position
				if Grid.cell_in_map(cell) and cell != current_position:
					var highlight = green_cell.instance()
					add_child(highlight)
					highlighted_cells.append(highlight)
					Grid.hightlight_cell(highlight, cell)
	
