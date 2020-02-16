class Cell:
	var occupied = false
	var occupied_by
	var terrain
	var position
	
	# Parameters used for A* Path finding
	var g
	var h
	var f
	var parent
	
	func _init(type, position):
		self.set_terrain(type)
		self.position = position
		
	func get_position():
		return self.position
		
	func set_terrain(type):
		self.terrain = Terrain.new(type)
		
	func get_terrain():
		return self.terrain
		
	func is_occupied():
		return self.occupied
		
	func get_occupant():
		return self.occupied_by
		
	func set_occupied(character):
		self.occupied = true
		self.occupied_by = character
		
	func remove_occupied():
		self.occupied = false
		
	func movement_cost():
		return self.terrain.movement_cost()
		
	static func sort_ascending(a, b):
		return a.f < b.f

		
class Terrain:
	var movement_cost
	var type

	func _init(type):
		if type == "Grass" or type == "grass":
			self.movement_cost = 1
			self.type = "grass"

	func movement_cost():
		return self.movement_cost
