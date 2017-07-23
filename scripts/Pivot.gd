extends Node2D

var timer;

func _ready():
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_timer_process_mode(0)
	timer.set_wait_time(1.5)
	timer.connect("timeout", self, "_timer_callback")
	add_child(timer)

func rotate():
	timer.start()
	get_node("AnimatedSprite").play()
	get_node("SamplePlayer2D").play("pivot")
	get_node("/root/Pinball").score += 200

func _timer_callback():
	timer.stop()
	get_node("AnimatedSprite").stop()

