extends MarginContainer

onready var position_text = get_node("Rows/Position")
onready var speed_text = get_node("Rows/Speed")
onready var background = get_node("Background")

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func update_panel(pos, speed, is_ally):
	position_text.text = String(pos.x) + ", " + String(pos.y)
	speed_text.text = "Speed: " + String(speed)

	if is_ally:
		background.color = Color("161c4a")
	else:
		background.color = Color("4a1616")

func _on_CharacterController_on_deselect():
	visible = false


func _on_CharacterController_on_select():
	visible = true
