extends Panel

onready var position_text = get_node("Position")
onready var speed_text = get_node("Speed")

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_panel(pos, speed):
	position_text.text = String(pos.x) + ", " + String(pos.y)
	speed_text.text = "Speed: " + String(speed)
	

func _on_Character_on_select():
	visible = true


func _on_Character_on_deselect():
	visible = false
