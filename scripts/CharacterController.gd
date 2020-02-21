extends Node2D

var green_cell = preload("res://map/CellHighlight.tscn")
var movement_indicator = preload("res://map/movement_indicator.tscn")
onready var grid = get_node("/root/Game/Map/Grid")
onready var character_panel = get_node("/root/Game/CanvasLayer/CharacterPanel")

onready var blue_characters = get_node("BlueTeam")
onready var red_characters = get_node("RedTeam")

var blue_team_units = []
var red_team_units = []
var highlighted_cells = [] 
var paths_to_highlighted_cells = {}
var movement_indicators = []
var movement_indicator_target
var selected
var selected_is_current_team
var selected_cells_passed = 0
var turn

signal on_select
signal on_deselect

enum Turn {blue, red}

func _ready():
	selected = null
	selected_is_current_team = null
	turn = Turn.blue
	for blue in blue_characters.get_children():
		blue.change_to_blue()
		blue_team_units.append(blue)
		
	for red in red_characters.get_children():
		red.change_to_red()
		red_team_units.append(red)

func _process(_delta):
	if selected != null and selected_is_current_team == true and selected.moving == false and highlighted_cells.empty():
		highlight_reachable_cells()
		
	# Show path to highlighted cell being hovered
	if selected != null:
		if selected.moving == false:
			update_movement_indicators()
		else:
			clear_movement_indicators_behind_player()
		
	# TODO: this should be triggered by some master game controller which emits an  event that the turn is over
	# in this trigggered function it could get the turn state by calling some function in the master game controller
	if Input.is_action_just_pressed("end_turn"):
		change_turn()
	# TAB - cycle between all blue_team_units
		
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var cell = grid.world_to_map(get_global_mouse_position())
		if not (selected != null and selected.moving):
			if event.button_index == BUTTON_LEFT:
				if selected != null and selected.current_position == cell:
					return
				var blue_unit = get_blue_unit_in_cell(cell)
				var red_unit = get_red_unit_in_cell(cell)
				if blue_unit != null or red_unit != null:
					if selected != null and selected.current_position != cell:
						clear_selected()
					if blue_unit != null:
						blue_unit.select()
						selected = blue_unit
						if turn == Turn.blue:
							selected_is_current_team = true
							highlight_reachable_cells()
					elif red_unit != null:
						red_unit.select()
						selected = red_unit
						if turn == Turn.red:
							selected_is_current_team = true
							highlight_reachable_cells()
					update_character_panel()

				elif selected != null:
					clear_selected()
				
			if event.button_index == BUTTON_RIGHT:
				if selected != null and selected_is_current_team == true and selected.current_position != cell:
					execute_action(cell)

func execute_action(target_position):
	if valid_movement_target(target_position):
		selected.move_to(target_position, paths_to_highlighted_cells[target_position])
		clear_highlighted_cells()
	# todo - some other possible action, some sort of feedback if no action is available

func get_blue_unit_in_cell(cell):
	for blue_team in blue_team_units:
		if blue_team != null:
			if blue_team.current_position == cell:
				return blue_team
	return null
	
func get_red_unit_in_cell(cell):
	for red_team in red_team_units:
		if red_team != null:
			if red_team.current_position == cell:
				return red_team
	return null
	
func change_turn():
	if turn == Turn.blue:
		turn = Turn.red
		for red_team in red_team_units:
			red_team.next_turn()
	else:
		turn = Turn.blue
		for blue_team in blue_team_units:
			blue_team.next_turn()

func highlight_reachable_cells():
	for i in range(-selected.remaining_movement, selected.remaining_movement+1):
		for j in range(-selected.remaining_movement, selected.remaining_movement+1):
			var cell = Vector2(i, j) + selected.current_position
			if grid.distance(cell, selected.current_position) <= selected.remaining_movement*128:
				if grid.cell_in_map(cell) and cell != selected.current_position:
					paths_to_highlighted_cells[cell] = grid.get_movement_path(selected.current_position, cell)
					if not paths_to_highlighted_cells[cell].empty():
						var highlight = green_cell.instance()
						highlight.z_as_relative = false
						highlight.z_index = -8
						add_child(highlight)
						highlighted_cells.append(highlight)
						grid.hightlight_cell(highlight, cell)
					
		
func valid_movement_target(target):
	for cell in highlighted_cells:
		var cell_position = grid.world_to_map(cell.global_position)
		if target == cell_position:
			return true
	return false

func update_movement_indicators():
	var temp = grid.world_to_map(get_global_mouse_position())
	if temp == movement_indicator_target:
		return
	if temp != movement_indicator_target:
		clear_movement_indicators()
	if selected != null and selected.moving == false and not highlighted_cells.empty() and paths_to_highlighted_cells.has(temp):
		movement_indicator_target = temp
		var path = paths_to_highlighted_cells[temp]
		var previous = selected.current_position
		
		for p in path:
			var indicator_location_1 = (grid.map_to_world_fixed(previous) + grid.map_to_world_fixed(p.position)) / 2
			var indicator_location_2 = grid.map_to_world_fixed(p.position)
			previous = p.position
			var indicator1 = movement_indicator.instance()
			var indicator2 = movement_indicator.instance()
			indicator1.z_as_relative = false
			indicator1.z_index = -1
			indicator2.z_as_relative = false
			indicator2.z_index = -1
			if path.back() == p:
				indicator2.global_scale *= 2
				indicator2.offset.y /= 2
			movement_indicators.append(indicator1)
			movement_indicators.append(indicator2)
			indicator1.global_position = indicator_location_1
			indicator2.global_position = indicator_location_2
			add_child(indicator1)
			add_child(indicator2)
	else:
		clear_movement_indicators()

func clear_movement_indicators_behind_player():
	if selected.cells_passed != selected_cells_passed:
		movement_indicators.pop_front().queue_free()
		movement_indicators.pop_front().queue_free()
		selected_cells_passed = selected.cells_passed	
	
func clear_highlighted_cells():
	for n in highlighted_cells:
		n.queue_free()
	highlighted_cells.clear()
	paths_to_highlighted_cells.clear()
	
func clear_movement_indicators():
	for i in movement_indicators:
		i.queue_free()
	movement_indicators.clear()
	
func clear_selected():
	selected.deselect()
	clear_highlighted_cells()
	selected = null
	selected_is_current_team = false
	emit_signal("on_deselect")
	
func update_character_panel():
	character_panel.update_panel(selected.current_position, selected.move_range, selected_is_current_team)
	emit_signal("on_select")

