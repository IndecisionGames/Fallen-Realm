extends Node2D

var selected = false
var movement = 2
var remaining_movement = movement

var current_position;

var move_speed = 300
var movement_vec = Vector2(0,0)
var next_cell;
var final_cell;
var moving = false

var path

signal on_select
signal on_deselect

onready var Grid = get_node("/root/Game/Map/Grid")
onready var character_sprite = get_node("CharacterSprite")

func _ready():
	current_position = Grid.world_to_map(global_position)
	global_position = Grid.map_to_world_fixed(current_position)
	
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
					

func go_to_next_cell():
	next_cell = path.pop_front().position
	movement_vec = (Grid.map_to_world_fixed(next_cell) - Grid.map_to_world_fixed(current_position)).normalized()
	character_sprite.look_at(Grid.map_to_world_fixed(next_cell))
	character_sprite.rotate(deg2rad(-90))
	
func in_range(delta):
	if(movement_vec.length_squared() == 0):
		return true
	var offset = Grid.map_to_world_fixed(next_cell) - global_position
	if offset.length_squared() < 2 * (movement_vec * move_speed * delta).length_squared():
		set_global_position(Grid.map_to_world_fixed(next_cell))
		current_position = next_cell
		remaining_movement -= 1
		return true
	return false
	
func select():
	selected = true

func deselect():
	selected = false
	
func move_to(cell):
	path = []
	final_cell = cell
	path = Grid.get_movement_path(current_position, final_cell)
	go_to_next_cell()
	moving = true
	
func next_turn():
	remaining_movement = movement
