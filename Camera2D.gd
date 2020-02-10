extends Camera2D

var move_speed = 500;
var zoom_speed = 0.05;
var current_zoom = 1;
var min_zoom = 0.3;
var max_zoom = 1.8;
var moving_left = false;
var moving_right = false;
var moving_up = false;
var moving_down = false;

func _process(delta):
	current_zoom = get_zoom().x
	var camera_location = get_offset()
	var move_vec = Vector2()	
	
	# Camera Movement
	if Input.is_action_pressed("camera_up") or moving_up:
		move_vec.y -= 1
	if Input.is_action_pressed("camera_down") or moving_down:
		move_vec.y += 1
	if Input.is_action_pressed("camera_left") or moving_left:
		move_vec.x -= 1
	if Input.is_action_pressed("camera_right") or moving_right:
		move_vec.x += 1
	move(camera_location + (move_vec * move_speed * current_zoom * delta * 2))
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_UP :
			zoom_in()
		if event.button_index == BUTTON_WHEEL_DOWN:
			zoom_out()
	if event is InputEventMouseMotion and Input.is_action_pressed("camera_move"):
		var move_vec = event.relative
		move(get_offset() - (move_vec * current_zoom))

func move(target):
	set_offset(target)
	
func zoom_out():
	current_zoom += (zoom_speed)
	if current_zoom > max_zoom:
		current_zoom = max_zoom
	zoom_camera(current_zoom);
	
func zoom_in():
	current_zoom -= (zoom_speed)
	if current_zoom < min_zoom:
		current_zoom = min_zoom
	else:
		var move_vec = (get_global_mouse_position() - get_offset()).normalized()
		move(get_offset() + (move_vec * move_speed * zoom_speed))
	zoom_camera(current_zoom);
		
func zoom_camera(current_zoom):
	set_zoom(Vector2(current_zoom, current_zoom))


func _on_Left_mouse_entered():
	moving_left = true;


func _on_Left_mouse_exited():
	moving_left = false;


func _on_Right_mouse_entered():
	moving_right = true;


func _on_Right_mouse_exited():
	moving_right = false;


func _on_Up_mouse_entered():
	moving_up = true;


func _on_Up_mouse_exited():
	moving_up = false;


func _on_Down_mouse_entered():
	moving_down = true;


func _on_Down_mouse_exited():
	moving_down = false;


func _on_UpLeft_mouse_entered():
	moving_up = true;
	moving_left = true;
	
func _on_UpLeft_mouse_exited():
	moving_up = false;
	moving_left = false;

func _on_DownLeft_mouse_entered():
	moving_down = true;
	moving_left = true;


func _on_DownLeft_mouse_exited():
	moving_down = false;
	moving_left = false;


func _on_UpRight_mouse_entered():
	moving_up = true;
	moving_right = true;


func _on_UpRight_mouse_exited():
	moving_up = false;
	moving_right = false;


func _on_DownRight_mouse_entered():
	moving_down = true;
	moving_right = true;


func _on_DownRight_mouse_exited():
	moving_down = false;
	moving_right = false;
