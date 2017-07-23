extends RigidBody2D

var BallPos = null
onready var pinball = get_node("/root/Pinball")

func _ready():
	BallPos = get_node("/root/Pinball/BallPos")
	set_fixed_process(true)

func _fixed_process(delta):
	#Know if the game is lose
	if pinball.multiBallCounter != 1:
		for i in range(1,pinball.multiBallCounter):
			if get_node("/root/Pinball").has_node("Ball" + pinball.ballName[i]):
				if get_node("/root/Pinball/Ball" + pinball.ballName[i]).get_pos().y > 569:
					get_node("/root/Pinball/Ball" + pinball.ballName[i]).queue_free()
			else:
				if get_node("/root/Pinball/Ball").get_pos().y > 569:
					lose()
	else:
		if get_pos().y > 569:
			lose()
	
	
func lose():
	#Réouverture du clapet
	pinball.event_02 = false
	pinball.get_node("Event_02/Clapet").set_rot(0)
	#Suppression du tilt
	pinball.isTilted = false
	#Retire les bonus en cours (x1, x3 et x5)
	if pinball.bonus > 0:
		pinball.get_node("Score/Bonus").removeBonus()
		get_node("/root/Pinball/Score/Bonus/x3").hide()
		get_node("/root/Pinball/Score/Bonus/x5").hide()
	pinball.resetAbcd()
	pinball.resetFly()
	#S'il a activé le bonus "FreeGameScore"
	if pinball.freeGameScore < pinball.score:
		pinball.credit += 1
	pinball.balls += 1
	#S'il lui reste aucune balle
	if pinball.balls > pinball.d_balls:
		Reset()
	else:
		set_pos(BallPos.get_pos())

func Reset():
	#Remise du score et balle à 0
	pinball.score = 0
	pinball.balls = 0
	#S'il reste 0 crédit
	if pinball.credit == 0:
		print('Perdu!')
		pinball.jeton = false
		pinball.start = false
		pinball.gamePlayed = 0
		set_pos(pinball.get_node("BallPos").get_pos())
		hide()
	#S'il reste plus de 0 crédit
	else:
		print('Crédit(s) restant: ' + String(pinball.credit))
		pinball.start = false
		hide()
	pinball.resetNight()
	pinball.resetAbcd()
	pinball.resetDrop()
	pinball.resetFly()

