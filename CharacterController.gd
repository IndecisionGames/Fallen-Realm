extends Node2D

enum Turn {ally, enemy}
var green_cell = preload("res://map/CellHighlight.tscn")
onready var grid = get_node("/root/Game/Map/Grid")
onready var character_panel = get_node("/root/Game/CanvasLayer/UI/CharacterPanel")
onready var test_character = get_node("Character") # temp

var allies = []
var enemies = []
var highlighted_cells = [] 
var selected
var selected_is_ally
var turn

func _ready():
	selected = null
	selected_is_ally = null
	turn = Turn.ally
	# TODO - populate allies and enemies - create 2 children nodes (allies and enemies) and put characters under them
	# for now adding a test character
	allies.append(test_character)

func _process(_delta):
	if selected != null and selected_is_ally == true and turn == Turn.ally and selected.moving == false and highlighted_cells.empty():
		highlight_reachable_cells()
	if Input.is_action_just_pressed("end_turn"):
		change_turn()
	# TAB - cycle between all allies
		

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var cell = grid.world_to_map(get_global_mouse_position())
		if not (selected != null and selected.moving):
			if event.button_index == BUTTON_LEFT:
				if selected != null and selected.current_position == cell:
					return
				var ally = get_ally_in_cell(cell)
				var enemy = get_enemy_in_cell(cell)
				if ally != null or enemy != null:
					if selected != null and selected.current_position != cell:
						selected.deselect()
						clear_highlighted_cells()
					if ally != null:
						ally.select()
						selected = ally
						selected_is_ally = true
						if turn == Turn.ally:
							highlight_reachable_cells()
						# todo - show friendly panel
					else:
						selected = enemy
						selected_is_ally = false
						# todo - show enemy panel
				elif selected != null:
						selected.deselect()
						clear_highlighted_cells()
						selected = null
				
			if event.button_index == BUTTON_RIGHT:
				if turn == Turn.ally:
					if selected != null and selected_is_ally == true and selected.current_position != cell:
						execute_action(cell)

func execute_action(target_position):
	if valid_movement_target(target_position):
		clear_highlighted_cells()
		selected.move_to(target_position)
	# todo - some other possible action, some sort of feedback if no action is available

func get_ally_in_cell(cell):
	for ally in allies:
		if ally.current_position == cell:
			return ally
	return null
	
func get_enemy_in_cell(cell):
	for enemy in enemies:
		if enemy.current_position == cell:
			return enemy
	return null
	
func change_turn():
	if turn == Turn.ally:
		turn = Turn.enemy
		for enemy in enemies:
			enemy.next_turn()
	else:
		turn = Turn.ally
		for ally in allies:
			ally.next_turn()
	print(turn)

func highlight_reachable_cells():
	for i in range(-selected.remaining_movement, selected.remaining_movement+1):
		for j in range(-selected.remaining_movement, selected.remaining_movement+1):
			var cell = Vector2(i, j) + selected.current_position
			if grid.distance(cell, selected.current_position) <= selected.remaining_movement*128:
				if grid.cell_in_map(cell) and cell != selected.current_position:
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

func clear_highlighted_cells():
	for n in highlighted_cells:
		n.queue_free()
	highlighted_cells.clear()

#func update_character_panel():
#	character_panel.update_panel(current_position, move_speed)
#	emit_signal("on_select")

