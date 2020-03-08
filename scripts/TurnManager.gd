extends Node


var turn_num
var turn_team


signal on_turn_change


enum Turn {blue, red}

func _ready():
	turn_team = Turn.red
	turn_num = 0
#	emit_signal("on_turn_change", turn_team, turn_num)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if Input.is_action_just_pressed("end_turn"):
		change_turn()





func change_turn():
	turn_num = turn_num + 1
	
	if turn_team == Turn.blue:
		turn_team = Turn.red
	else:
		turn_team = Turn.blue
		
	emit_signal("on_turn_change", turn_team, turn_num)
