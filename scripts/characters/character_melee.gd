extends CharacterBase


func _ready():
	self.move_range = 3
	self.attach_range = 1
	self.attach_damage = 10
	self.health_points = 100
	
	self.grid = get_node("/root/Game/Map/Grid")
	self.character_sprite = get_node("CharacterSprite")
	
	self.current_position = grid.world_to_map(global_position)
	global_position = grid.map_to_world_fixed(current_position)
