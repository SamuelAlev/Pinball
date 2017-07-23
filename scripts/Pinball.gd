extends Node2D

#Pour savoir si le joueur a mis le jeton dans la machine
var jeton = false
var jetonNotPress = false
var start = false

#Variable par défaut du nombre de balles par partie et celle de jeu à l'initialisation
var d_balls = 5
var balls = 0

#Variable par défaut du nombre de crédit au lancement et celle de jeu à l'initialisation
var d_credit = 0
var credit = d_credit

#Variable score à l'initialisation
var score = 0

var gamePlayed = 0

#Var Tilt
var tiltForce = 10
var tiltProba = 0.42
var tiltLeft = false
var tiltRight = false
var isTilted = false

#Var Rotation paddle
var maxRot = 0.5
var speedRot = 0.12

#Var Bonus
var freeGameScore = 650000

#Var lettre (rip)
var f = false
var l = false
var y = false
var fly = false

var a = false
var b = false
var c = false
var d1 = false
var abcd = false

var n = false
var i = false
var g = false
var h = false
var t = false
var night = false

var nightfly = false
var multiBallCounter = 1
var ballName = [""," 1"," 2"," 3"]

var d2 = false
var r = false
var o = false
var p = false
var rop = false
var drop = false

var bonus_x = 1
var bonus = 0
var bonusFinishedSpawning = true

var ball = preload("res://scenes/Ball.tscn")
var balle
var ballnode = ("Ball" + ballName[multiBallCounter-1])

var event_01 = false
var balltopath
var event_02 = false
var event_05 = false

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	get_node("Gauche/Balls").set_text(String(balls))
	if gamePlayed != 0:
		get_node("Gauche/Score" + String(gamePlayed%5)).set_text(String(score))
	else: 
		get_node("Gauche/Score1").set_text(String(score))
	get_node("Gauche/Crédit").set_text(String(credit))
	
	#Jeton pour pouvoir commencer
	if Input.is_action_pressed("jeton") and bonusFinishedSpawning:
		if jetonNotPress:
			jetonNotPress = false
			print('Jeton inséré')
			jeton = true
			credit += 1
			get_node("Jeton").hide()
	if !Input.is_action_pressed("jeton"):
		jetonNotPress = true
	
	#Start pour commencer à jouer
	if Input.is_action_pressed("start") and jeton and !start:
		print('START')
		get_node("Start").hide()
		get_node("cacheArriere").hide()
		credit -= 1
		balls += 1
		spawnBall()
		start = true
		gamePlayed += 1
		print(gamePlayed)
	
	#En attente du jeton
	if !start:
		get_node("Ball").set_pos(get_node("BallPos").get_pos())
	
	#Pause
	if Input.is_action_pressed("pause"):
		get_tree().set_pause(true)
		get_node("Pause").show()
	
	#Input tilt
	if Input.is_action_pressed("tilt_left") and start:
		if !tiltLeft:
			tiltLeft = true
			randomize()
			if tiltProba < rand_range(0.4, 1):
				for i in range(multiBallCounter):
					if has_node("Ball" + ballName[i]):
						get_node("Ball" + ballName[i]).apply_impulse(Vector2(0,0), Vector2(-80,10))
			else: 
				print('Tilted!')
				isTilted = true
	if !Input.is_action_pressed("tilt_left") and start:
		tiltLeft = false

	if Input.is_action_pressed("tilt_right") and start:
		if !tiltRight:
			tiltRight = true
			randomize()
			if tiltProba < rand_range(0.4, 1):
				for i in range(multiBallCounter):
					if has_node("Ball" + ballName[i]):
						get_node("Ball" + ballName[i]).apply_impulse(Vector2(0,0), Vector2(80,10))
			else:
				print('Tilted!') 
				isTilted = true
	if !Input.is_action_pressed("tilt_right") and start:
		tiltRight = false
	
	#If Tilted
	if isTilted:
		tilted()
	
	#Event Follow Path
	if event_01:
		#Incrémente l'offset automatiquement.
		get_node("Event_01/Path/PathFollow").set_offset(get_node("Event_01/Path/PathFollow").get_offset() + (70*delta))
		#Calque la position de l'offset sur la balle.
		balltopath.set_pos(get_node("Event_01/Path/PathFollow").get_pos())
		if get_node("Event_01/Path/PathFollow").get_offset() >= 208:
			balltopath.set_linear_velocity(Vector2(200,-200)) #Force appliquée à la fin à la balle
			get_node("Event_01/Path/PathFollow").set_offset(0) #Remet à 0 l'offset de déplacement
			event_01 = false
			
	#Event quand la balle passe pour fermer le clapet 
	#pour qu'elle ne retourne pas dans le trou
	if event_02:
		get_node("Event_02/Clapet").set_rot(43)
	
	if bonus > 6:
		get_node("Score/Bonus/x3").show()
		bonus_x = 3
		if bonus > 11:
			get_node("Score/Bonus/x5").show()
			bonus_x = 5
	
	if f and l and y and !fly:
		fly = true
		score += 5000
	if f and l and y:
		get_node("Score/F").show()
		f = false
		get_node("Score/L").show()
		l = false
		get_node("Score/Y").show()
		y = false
	
	if a and b and c and d1 and !abcd:
		abcd = true
	if a and b and c and d1:
		get_node("Score/A").show()
		a = false
		get_node("Score/B").show()
		b = false
		get_node("Score/C").show()
		c = false
		get_node("Score/D1").show()
		d1 = false
	
	#Bonus NIGHT
	if n and i and g and h and t and !night:
		night = true
		score += 10000
		
	#Bonus NIGHT et FLY
	if night and fly and !nightfly:
		nightfly = true
		score += 25000
		resetAbcd()
	
	if nightfly:
		get_node("Score/Block").set_hidden(0)
	
	#Bonus D après ROP
	if r and o and p and !rop:
		get_node("Score/Bonus/Special").show()
		rop = true
	if rop and d2:
		credit += 1
		drop = true
		score += 10000
		resetDrop()
	if d2 and !rop:
		resetDrop()
	
	if event_05:
		if multiBallCounter <= 4:
			for i in range(multiBallCounter-1):
				get_node("Ball" + ballName[i]).set_pos(Vector2(get_node("Event_05/Position2D").get_pos().x - (i * 15), get_node("Event_05/Position2D").get_pos().y))
		
		if abcd:
			print('Release')
			event_05 = false
			resetFly()
			resetNight()
			get_node("Score/Block").set_hidden(1)
		for i in range(multiBallCounter):
			if has_node("Ball" + ballName[i]):
				if get_node("Ball" + ballName[i]).get_pos().y > 566:
					print('Release')
					event_05 = false
					resetFly()
					resetNight()
					get_node("Score/Block").set_hidden(1)
		
func released():
	if multiBallCounter == 4:
		#release()
		print('Release')
		event_05 = false
		resetFly()
		resetNight()
		get_node("Score/Block").set_hidden(1)

#Si tilté
func tilted():
	get_node("FlipperD").set_rot(0)
	get_node("FlipperG").set_rot(0)

#Spawn la balle
func spawnBall():
	get_node("Ball").set_pos(get_node("BallPos").get_pos())
	get_node("Ball").show()


func _on_Event_01_body_enter(body):
	if !nightfly:
		event_01 = true
		balltopath = body
		print('Event_01: Follow path')
	else:
		event_05 = true
		print('Event_05: Multi-ball')
		
		if multiBallCounter < 4:
			balle = ball.instance()
			balle.set_pos(get_node("BallPos").get_pos())
			balle.set_name("Ball" + ballName[multiBallCounter])
			add_child(balle)
			event_02 = false
			get_node("Event_02/Clapet").set_rot(0)
			multiBallCounter += 1
		else:
			released()
	pass

func _on_Event_02_body_enter(body):
	if !event_02:
		event_02 = true
		print('Event_02: Fermeture du clapet')
	pass

func _on_Event_03_01_body_enter(body):
	print('Event_03: Pivot (01)')
	get_node("Event_03/Pivot1").rotate()
	pass

func _on_Event_03_02_body_enter(body):
	print('Event_03: Pivot (02)')
	get_node("Event_03/Pivot2").rotate()
	pass

func _on_Reprendre_button_down():
	get_tree().set_pause(false)
	get_node("Pause").hide()

func _on_Options_button_down():
	get_node("Options").show()

func _on_Quitter_button_down():
	get_tree().quit()

func _on_Event_04_body_enter(body):
	print('Event_04: Explosion')
	get_node("Event_04/Explosion").holdAndShoot(body)
	pass

func _on_Bounce_body_exit(body):
	score += 90

func _on_BouncePetit_body_exit(body):
	score += 50

func _on_Passage1_body_enter(body):
	score += 300

func _on_Passage3_body_enter(body):
	score += 5000

func _on_F_body_exit(body):
	if !f:
		f = true
		bonus += 1
		score += 1000
		get_node("Score/Bonus").updateBonus()
		get_node("Score/F").hide()

func _on_L_body_exit(body):
	if !l:
		l = true
		bonus += 1
		score += 1000
		get_node("Score/Bonus").updateBonus()
		get_node("Score/L").hide()

func _on_Y_body_exit(body):
	if !y:
		y = true
		bonus += 1
		score += 1000
		get_node("Score/Bonus").updateBonus()
		get_node("Score/Y").hide()

#Réactive les bonus abcd fly
func reshowBonus():
	resetAbcd()
	resetFly()

#Reset les variables de abcd
func resetAbcd():
	get_node("Score/A").show()
	a = false
	get_node("Score/B").show()
	b = false
	get_node("Score/C").show()
	c = false
	get_node("Score/D1").show()
	d1 = false
	abcd = false

#Reset les variables de fly
func resetFly():
	get_node("Score/F").show()
	f = false
	get_node("Score/L").show()
	l = false
	get_node("Score/Y").show()
	y = false
	fly = false

#Reset les variables de night
func resetNight():
	get_node("Score/N").show()
	n = false
	get_node("Score/I").show()
	i = false
	get_node("Score/G").show()
	g = false
	get_node("Score/H").show()
	h = false
	get_node("Score/T").show()
	t = false
	night = false
	nightfly = false

#Reset les variables de drop
func resetDrop():
	d2 = false
	get_node("Score/D2").show()
	r = false
	get_node("Score/R").show()
	o = false
	get_node("Score/O").show()
	p = false
	get_node("Score/P").show()
	rop = false
	drop = false
	get_node("Score/Bonus/Special").hide()

func _on_A_body_exit(body):
	if !a:
		a = true
		bonus += 1
		score += 1000
		get_node("Score/Bonus").updateBonus()
		get_node("Score/A").hide()

func _on_B_body_exit(body):
	if !b:
		b = true
		bonus += 1
		score += 1000
		get_node("Score/Bonus").updateBonus()
		get_node("Score/B").hide()

func _on_C_body_exit(body):
	if !c:
		c = true
		bonus += 1
		score += 1000
		get_node("Score/Bonus").updateBonus()
		get_node("Score/C").hide()

func _on_D1_body_exit(body):
	if !d1:
		d1 = true
		bonus += 1
		score += 1000
		get_node("Score/Bonus").updateBonus()
		get_node("Score/D1").hide()

func _on_N_body_enter(body):
	if !n:
		n = true
		bonus += 1
		score += 2000
		get_node("Score/Bonus").updateBonus()
		get_node("Score/N").hide()

func _on_I_body_enter(body):
	if !i:
		i = true
		bonus += 1
		score += 2000
		get_node("Score/Bonus").updateBonus()
		get_node("Score/I").hide()

func _on_G_body_enter(body):
	if !g:
		g = true
		bonus += 1
		score += 2000
		get_node("Score/Bonus").updateBonus()
		get_node("Score/G").hide()

func _on_H_body_enter(body):
	if !h:
		h = true
		bonus += 1
		score += 2000
		get_node("Score/Bonus").updateBonus()
		get_node("Score/H").hide()

func _on_T_body_enter(body):
	if !t:
		t = true
		bonus += 1
		score += 2000
		get_node("Score/Bonus").updateBonus()
		get_node("Score/T").hide()

func _on_D2_body_enter(body):
	if !d2:
		d2 = true
		score += 2000
		get_node("Score/D2").hide()

func _on_R_body_enter(body):
	if !r:
		r = true
		score += 2000
		get_node("Score/R").hide()

func _on_O_body_enter(body):
	if !o:
		o = true
		score += 2000
		get_node("Score/O").hide()

func _on_P_body_enter(body):
	if !p:
		p = true
		score += 2000
		get_node("Score/P").hide()