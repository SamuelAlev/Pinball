extends RigidBody2D

#Rotation du flipper
var rotation = 0

var sound_to_play = true

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	#Cap les max et min de rotation:
	if rotation >= get_node("/root/Pinball").maxRot:
		rotation = get_node("/root/Pinball").maxRot
	if rotation <= 0:
		rotation = 0

	#Commence la rotation lorsque la touche est pressée et joue le son
	if Input.is_action_pressed("paddle_left") and !get_node("/root/Pinball").isTilted:
		rotation += get_node("/root/Pinball").speedRot
		if sound_to_play:
			get_node("SamplePlayer").play("paddle")
			sound_to_play = false
	else:
		rotation -= get_node("/root/Pinball").speedRot
		sound_to_play = true

	set_rot(rotation)