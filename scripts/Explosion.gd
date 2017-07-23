extends Node2D

var timer
var body

func _ready():
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_timer_process_mode(0)
	timer.set_wait_time(1.5)
	timer.connect("timeout", self, "_timer_callback")
	add_child(timer)

func holdAndShoot(ball):
	body = ball
	get_node("/root/Pinball").score += 100
	set_process(true)
	timer.start()

func _timer_callback():
	set_process(false)
	timer.stop()
	print('Event_04: FIRE!')
	body.set_linear_velocity(Vector2(0,-600))
	get_node("SamplePlayer2D").play("bombfall")

func _process(delta):
	body.set_pos(get_pos())

