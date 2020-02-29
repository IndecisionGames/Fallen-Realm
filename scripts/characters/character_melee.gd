extends CharacterBase


func _ready():
	self.move_range = 2
	self.attack_range = 1
	self.attack_damage = 10
	self.health_points = 100
	
	self.grid = get_node("/root/Game/Map/Grid")
	self.character_sprite = get_node("CharacterSprite")
	self.banner = get_node("Banner")
	self.blue_banner_texture = load("res://characters/knight/banner/knight_banner_blue.png")
	self.blue_banner_selected_texture = load("res://characters/knight/banner/knight_banner_blue_selected.png")
	self.red_banner_texture = load("res://characters/knight/banner/knight_banner_red.png")
	self.red_banner_selected_texture = load("res://characters/knight/banner/knight_banner_red_selected.png")
	
	# self.character_sprite.set_texture(load("res://characters/knight-128.png"))
	
	self.current_position = grid.world_to_map(global_position)
	global_position = grid.map_to_world_fixed(current_position)
	
	._ready()
