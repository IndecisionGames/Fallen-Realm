extends Node2D
class_name CharacterBase

var move_range
var attack_range
var attack_damage
var health_points

var current_position;
var moving = false

var move_speed = 200
var movement_vec = Vector2(0,0)
var next_cell;
var final_cell;
var cells_passed = 0;
var path
var remaining_movement

signal on_select
signal on_deselect

onready var grid
onready var character_sprite
onready var banner

onready var banner_texture
onready var banner_selected_texture
onready var blue_banner_texture
onready var blue_banner_selected_texture
onready var red_banner_texture
onready var red_banner_selected_texture

func _ready():
	remaining_movement = move_range

func _process(delta):
	process_movement(delta)
	
func process_movement(delta):
	if moving:
		if in_range(delta):
			movement_vec = Vector2(0,0)
			if next_cell == final_cell:
				moving = false
				character_sprite.play("default")
			else:
				go_to_next_cell()
		else:
			set_global_position(get_global_position() + movement_vec * move_speed * delta)

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
	cells_passed += 1
	next_cell = path.pop_front().position
	movement_vec = (grid.map_to_world_fixed(next_cell) - grid.map_to_world_fixed(current_position)).normalized()
	if movement_vec.x < 0:
		# face left
		character_sprite.set_flip_h(true)
	elif movement_vec.x > 0:
		# face right
		character_sprite.set_flip_h(false)


# Called by Controller
func select():
	banner.set_texture(banner_selected_texture)

func deselect():
	banner.set_texture(banner_texture)
	
func new_turn():
	remaining_movement = move_range

func move_to(cell, path_to_cell):
	path = path_to_cell
	final_cell = cell
	cells_passed = 0
	go_to_next_cell()
	moving = true
	character_sprite.play("walk")
	

# Setup
func change_to_blue():
	banner_texture = blue_banner_texture
	banner_selected_texture = blue_banner_selected_texture
	banner.set_texture(banner_texture)
	init_sprite()
	
func change_to_red():
	banner_texture = red_banner_texture
	banner_selected_texture = red_banner_selected_texture
	banner.set_texture(banner_texture)
	init_sprite()

func init_sprite():
	character_sprite.set_visible(true)
	character_sprite.play("default")
