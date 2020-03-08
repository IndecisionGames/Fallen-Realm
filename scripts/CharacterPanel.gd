extends MarginContainer

onready var position_text = get_node("Rows/Position")
onready var speed_text = get_node("Rows/Speed")
onready var background = get_node("Background")

enum Turn {blue, red}

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func update_panel(pos, speed, team):
	position_text.text = String(pos.x) + ", " + String(pos.y)
	speed_text.text = "Speed: " + String(speed)

	if team == Turn.blue:
		background.color = Color("101e63")
	elif team == Turn.red:
		background.color = Color("631010")

func _on_CharacterController_on_deselect():
	visible = false


func _on_CharacterController_on_select(character, is_ally):
	update_panel(character.current_position, character.move_range, is_ally)
	visible = true


func _on_TurnManager_on_turn_change():
	pass # Replace with function body.
