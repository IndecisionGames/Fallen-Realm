extends Node2D

enum Direction{
	North,
	South,
	East,
	West
}

var green_cell = preload("res://map/CellHighlight.tscn")

var selected = false
var movement = 2
var current_position;
var target_position;
var under_mouse = false;
var highlighted_cells = [];
var global_cancel_origin = false
var facing = Direction.South

var move_speed = 300
var movement_vec = Vector2(0,0)
var next_cell;
var final_cell;
var moving = false

onready var Grid = get_node("/root/Game/Map/Grid")
onready var character_sprite = get_node("CharacterSprite")

func _ready():
	add_to_group("characters")
	current_position = Grid.world_to_map(global_position)
	
func _process(delta):
	check_under_mouse()
	if moving:
		if in_range(next_cell):
			movement_vec = Vector2(0,0)
			if next_cell == final_cell:
				moving = false
			else:
				pick_next_cell()
		else:
			set_global_position(get_global_position() + movement_vec * move_speed * delta)
					

func pick_next_cell():
	var remaining = final_cell - current_position
	if remaining.x > 0: # move right
		next_cell = current_position + Vector2(1,0)
		facing = Direction.East
		character_sprite.set_global_rotation_degrees(-90)
	elif remaining.x < 0: # move left
		next_cell = current_position + Vector2(-1,0)
		facing = Direction.West
		character_sprite.set_global_rotation_degrees(90)
	elif remaining.y > 0: # move down
		next_cell = current_position + Vector2(0,1)
		facing = Direction.South
		character_sprite.set_global_rotation_degrees(0)
	elif remaining.y < 0: # move up
		next_cell = current_position + Vector2(0,-1)
		facing = Direction.North
		character_sprite.set_global_rotation_degrees(180)
	movement_vec = (Grid.map_to_world_fixed(next_cell) - Grid.map_to_world_fixed(current_position)).normalized()
	
func in_range(cell):
	var target = Grid.map_to_world_fixed(cell)
	var offset = target - global_position
	var passed = false
	if (facing == Direction.North and offset.y > 0) or (facing == Direction.South and offset.y < 0) or (facing == Direction.East and offset.x < 0) or (facing == Direction.West and offset.x > 0):
		set_global_position(target)
		current_position = cell
		return true
	return false
	
func select():
	selected = true
	global_cancel_origin = true
	get_tree().call_group("characters", "cancel")
	highlight_reachable_cells()

func cancel():
	if not global_cancel_origin:
		for n in highlighted_cells:
			n.queue_free()
		highlighted_cells.clear()
		selected = false
	global_cancel_origin = false
	
func act():
	if valid_movement_target(target_position):
		move_to(target_position)
	cancel()
	
func move_to(cell):
	final_cell = cell
	pick_next_cell()
	moving = true
	
func check_under_mouse():
	under_mouse =  (Grid.world_to_map(get_global_mouse_position()) == current_position)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			if under_mouse and not selected and not moving:
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
			var cell = Vector2(i, j) + current_position
			if Grid.distance(cell, current_position) <= movement*128:
				if Grid.cell_in_map(cell) and cell != current_position:
					var highlight = green_cell.instance()
					highlight.z_as_relative = false
					highlight.z_index = -8
					add_child(highlight)
					highlighted_cells.append(highlight)
					Grid.hightlight_cell(highlight, cell)

func valid_movement_target(target):
	for cell in highlighted_cells:
		var cell_position = Grid.world_to_map(cell.global_position)
		if target == cell_position:
			return true
	return false

