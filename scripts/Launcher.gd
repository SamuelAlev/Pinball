extends KinematicBody2D

var pos_x
var pos_y

# Position de l'offset de Y:
var push = 0

# Facteur de compression (scale) du sprite
var compress = 0.1

func _ready():
	set_process_input(true)
	set_fixed_process(true)

	pos_x = get_pos().x
	pos_y = get_pos().y

func _fixed_process(delta):
	# Cap les valeurs de Y:
	if push >= 32:
		push = 32
	if push <= 0:
		push = 0
	
	if get_node("Sprite").get_scale().y >= 0.8:
		get_node("Sprite").set_scale(Vector2(get_node("Sprite").get_scale().x, 0.8))
	if get_node("Sprite").get_scale().y <= 0.75:
		get_node("Sprite").set_scale(Vector2(get_node("Sprite").get_scale().x, 0.75))
	#Modifie la hauteur du ressort en fonction de si on appuye
	if Input.is_action_pressed("launcher") and get_node("/root/Pinball").bonusFinishedSpawning:
		push += 0.25
		get_node("Sprite").set_scale(Vector2(get_node("Sprite").get_scale().x, get_node("Sprite").get_scale().y - compress/100))
		set_pos(Vector2(pos_x, pos_y + push))
	else:
		push -= 1*(push/8)
		get_node("Sprite").set_scale(Vector2(get_node("Sprite").get_scale().x, get_node("Sprite").get_scale().y + compress/100))
		set_pos(Vector2(pos_x, pos_y + push))