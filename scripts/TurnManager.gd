extends Node


var turn_num = 0
var turn_team = Turn.blue


signal on_turn_change


enum Turn {blue, red}

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if Input.is_action_just_pressed("end_turn"):
		change_turn()





func change_turn():
	turn_num += turn_num
	
	if turn_team == Turn.blue:
		turn_team = Turn.red
	else:
		turn_team = Turn.blue
		
	emit_signal("on_turn_change", turn_team, turn_num)
