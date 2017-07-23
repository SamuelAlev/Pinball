extends Node2D

onready var pinball = get_node("/root/Pinball")

var timer;

var bombSprite
var bomb = preload("res://elements/bomb.png")

func updateBonus():
	print('Update Bonus !')
	bombSprite = Sprite.new()
	bombSprite.set_texture(bomb)
	bombSprite.set_scale(Vector2(0.75,0.75))
	randomize()
	bombSprite.set_rot(rand_range(-0.15708,0.15708))
	bombSprite.set_pos(Vector2(0, -(pinball.bonus * 10)))
	get_node("bonusSprite").add_child(bombSprite)

func removeBonus():
	pinball.bonusFinishedSpawning = false
	timer.start()
	if pinball.bonus > 0:
		get_node("bonusSprite").get_child(pinball.bonus-1).queue_free()
		pinball.score += 1000 * pinball.bonus_x
		pinball.bonus -= 1
		get_node("SamplePlayer2D").play("bomb")
	else: 
		timer.stop()
		pinball.reshowBonus()
		pinball.bonusFinishedSpawning = true

func _ready():
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_timer_process_mode(0)
	timer.set_wait_time(1)
	timer.connect("timeout", self, "_timer_callback")
	add_child(timer)

func _timer_callback():
	timer.stop()
	removeBonus()