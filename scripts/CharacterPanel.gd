extends MarginContainer

onready var background = get_node("Background")

onready var position = get_node("Rows/Position")
onready var health_points = get_node("Rows/HealthPoints")
onready var movement = get_node("Rows/Movement")

onready var attack_damage = get_node("Rows/AttackStats/Damage")
onready var attack_range = get_node("Rows/AttackStats/Range")

enum Turn {blue, red}

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func update_panel(pos, hp, movement_points, remaing_movement_points, a_damage, a_range, team):
	health_points.text = "HP: %s" % hp
	position.text = "Position: (%s, %s)" % [pos.x, pos.y]
	movement.text = "Movement: %s/%s" % [remaing_movement_points, remaing_movement_points]
	
	attack_damage.text = "Damage: %s" % a_damage
	attack_range.text = "Range: %s" % a_range

	if team == Turn.blue:
		background.color = Color("101e63")
	elif team == Turn.red:
		background.color = Color("631010")

func _on_CharacterController_on_deselect():
	visible = false


func _on_CharacterController_on_select(character, team):
	update_panel(character.current_position, character.health_points, character.move_range, character.remaining_movement, character.attack_damage, character.attack_range, team)
	visible = true
