extends MarginContainer

onready var team_text = get_node("Rows/Team")
onready var number_text = get_node("Rows/Number")
onready var background = get_node("Background")

enum Turn {blue, red}


func _on_TurnManager_on_turn_change(turn_team, turn_num):
	number_text.text = String(turn_num)
	if turn_team == Turn.blue:
		team_text.text = "Blue Team"
		background.color = Color("101e63")

	if turn_team == Turn.red:
		team_text.text = "Red Team"
		background.color = Color("631010")
