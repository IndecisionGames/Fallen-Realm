extends Node2D
class_name CharacterBase

var move_range = 2
var attach_range = 1
var attach_damage = 10
var health_points = 100

var current_position;
var moving = false

var move_speed = 300
var movement_vec = Vector2(0,0)
var next_cell;
var final_cell;
var path
var remaining_movement = move_range

signal on_select
signal on_deselect

onready var grid
onready var character_sprite

func _process(delta):
	print(remaining_movement)
	if moving:
		if in_range(delta):
			movement_vec = Vector2(0,0)
			if next_cell == final_cell:
				moving = false
			else:
				go_to_next_cell()
		else:
			set_global_position(get_global_position() + movement_vec * move_speed * delta)

func select():
	pass # could do something here

func deselect():
	pass # could do something here

func in_range(delta):
	if(movement_vec.length_squared() == 0):
		return true
	var offset = grid.map_to_world_fixed(next_cell) - global_position
	if offset.length_squared() < 2 * (movement_vec * move_speed * delta).length_squared():
		set_global_position(grid.map_to_world_fixed(next_cell))
		current_position = next_cell
		remaining_movement -= 1
		return true
	return false

func go_to_next_cell():
	next_cell = path.pop_front().position
	movement_vec = (grid.map_to_world_fixed(next_cell) - grid.map_to_world_fixed(current_position)).normalized()
	character_sprite.look_at(grid.map_to_world_fixed(next_cell))
	character_sprite.rotate(deg2rad(-90))

func move_to(cell):
	path = []
	final_cell = cell
	path = grid.get_movement_path(current_position, final_cell)
	go_to_next_cell()
	moving = true
	
func next_turn():
	remaining_movement = move_range
