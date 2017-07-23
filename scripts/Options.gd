extends Node2D

onready var pinball = get_node("/root/Pinball")

func _ready():
	set_process(true)

func _on_Close_button_down():
	hide()

func _on_Gravity_value_changed(value):
	
	get_node("/root/Pinball/Ball").set_gravity_scale(value)
	print("Vitesse de la balle: " + String(value))

func _on_TiltForce_value_changed(value):
	
	get_node("/root/Pinball").tiltForce = value
	print("Force de tilt: " + String(get_node("/root/Pinball").tiltForce))

func _on_TiltProba_value_changed(value):
	
	get_node("/root/Pinball").tiltProba = value
	print("Sensibilité aux tilts: " + String(get_node("/root/Pinball").tiltProba))

func _on_maxRot_value_changed(value):
	
	get_node("/root/Pinball").maxRot = value
	print("Rotation maximale: " + String(get_node("/root/Pinball").maxRot))

func _on_speedRot_value_changed(value):
	
	get_node("/root/Pinball").speedRot = value
	print("Vitesse de rotation: " + String(get_node("/root/Pinball").speedRot))

func _on_balls_value_changed(value):
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/balls/Value").set_text("Valeur: " + String(value))
	get_node("/root/Pinball").d_balls = value
	print("Nombre de balles: " + String(get_node("/root/Pinball").d_balls))

func _on_credit_value_changed(value):
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/credit/Value").set_text("Valeur: " + String(value))
	get_node("/root/Pinball").d_credit = value
	get_node("/root/Pinball").credit = value
	print("Crédit: " + String(get_node("/root/Pinball").d_credit))

func _on_Facile_button_down():
	pinball.get_node("Ball").set_gravity_scale(1)
	get_node("/root/Pinball").tiltProba = 0

func _on_Moyen_button_down():
	pinball.get_node("Ball").set_gravity_scale(1.5)
	get_node("/root/Pinball").tiltProba = 0.42

func _on_Difficile_button_down():
	pinball.get_node("Ball").set_gravity_scale(4)
	get_node("/root/Pinball").tiltProba = 0.91

func _process(delta):
	#Actualise le texte "valeur: " avec celles actuelles des var
	get_node("OptionsBackground/Options/TabContainer/Physiques/VBoxPhysiques/Vitesse/Value").set_text("Valeur: " + String(get_node("/root/Pinball/Ball").get_gravity_scale()))
	get_node("OptionsBackground/Options/TabContainer/Physiques/VBoxPhysiques/TiltForce/Value").set_text("Valeur: " + String(get_node("/root/Pinball").tiltForce))
	get_node("OptionsBackground/Options/TabContainer/Physiques/VBoxPhysiques/TiltProba/Value").set_text("Valeur: " + String(get_node("/root/Pinball").tiltProba))
	get_node("OptionsBackground/Options/TabContainer/Physiques/VBoxPhysiques/maxRot/Value").set_text("Valeur: " + String(get_node("/root/Pinball").maxRot))
	get_node("OptionsBackground/Options/TabContainer/Physiques/VBoxPhysiques/speedRot/Value").set_text("Valeur: " + String(get_node("/root/Pinball").speedRot))
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/freeGameScore/Value").set_text("Valeur: " + String(get_node("/root/Pinball").freeGameScore))
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/balls/Value").set_text("Valeur: " + String(get_node("/root/Pinball").d_balls))
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/credit/Value").set_text("Valeur: " + String(get_node("/root/Pinball").credit))
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/score/Value").set_text("Valeur: " + String(get_node("/root/Pinball").score))
	
	var dif = get_node("OptionsBackground/Options/TabContainer/Preset/VBoxPreset/Difficultés")
	#Facile
	if pinball.get_node("Ball").get_gravity_scale() == 1 and pinball.tiltProba == 0:
		get_node("OptionsBackground/Options/TabContainer/Preset/VBoxPreset/L_Current").set_text("Activé: Facile")
		dif.get_node("Facile").set_disabled(1)
		dif.get_node("Moyen").set_disabled(0)
		dif.get_node("Difficile").set_disabled(0)
		pass
	#Moyen
	elif pinball.get_node("Ball").get_gravity_scale() == 1.5 and pinball.tiltProba == 0.42:
		get_node("OptionsBackground/Options/TabContainer/Preset/VBoxPreset/L_Current").set_text("Activé: Moyen")
		dif.get_node("Facile").set_disabled(0)
		dif.get_node("Moyen").set_disabled(1)
		dif.get_node("Difficile").set_disabled(0)
		pass
	#Difficile
	elif pinball.get_node("Ball").get_gravity_scale() == 4 and pinball.tiltProba == 0.91:
		get_node("OptionsBackground/Options/TabContainer/Preset/VBoxPreset/L_Current").set_text("Activé: Difficile")
		dif.get_node("Facile").set_disabled(0)
		dif.get_node("Moyen").set_disabled(0)
		dif.get_node("Difficile").set_disabled(1)
		pass
	else:
		get_node("OptionsBackground/Options/TabContainer/Preset/VBoxPreset/L_Current").set_text("Activé: Custom")
		dif.get_node("Facile").set_disabled(0)
		dif.get_node("Moyen").set_disabled(0)
		dif.get_node("Difficile").set_disabled(0)
		pass

func _on_Save_button_up():
	var save = {}
	save["0"] = pinball.get_node("Ball").get_gravity_scale()
	save["1"] = pinball.tiltForce
	save["2"] = pinball.tiltProba
	save["3"] = pinball.maxRot
	save["4"] = pinball.speedRot
	save["5"] = pinball.freeGameScore
	save["6"] = pinball.d_balls
	save["7"] = pinball.d_credit
	save["8"] = pinball.score
	
	var savegame = File.new()
	savegame.open("user://Save_test.sav", File.WRITE)
	savegame.store_line( save.to_json() )
	savegame.close()

func _on_Load_button_up():
	var savegame = File.new()
	var infoload = {}
	savegame.open("user://Save_test.sav", File.READ)
	while (!savegame.eof_reached()):
		infoload.parse_json(savegame.get_line())
	savegame.close()
	pinball.get_node("Ball").set_gravity_scale(infoload["0"])
	pinball.tiltForce = infoload["1"]
	pinball.tiltProba = infoload["2"]
	pinball.maxRot = infoload["3"]
	pinball.speedRot = infoload["4"]
	pinball.freeGameScore = infoload["5"]
	pinball.d_balls = infoload["6"]
	pinball.credit = infoload["7"]
	pinball.score = infoload["8"]
	
func _on_LineEdit_text_changed(text):
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/freeGameScore/Value").set_text("Valeur: " + String(int(text)))
	get_node("/root/Pinball").freeGameScore = int(text)
	print("freeGameScore: " + String(get_node("/root/Pinball").freeGameScore))

func _on_Score_text_changed(text):
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/score/Value").set_text("Valeur: " + String(int(text)))
	get_node("/root/Pinball").score = int(text)
	print("Score: " + String(get_node("/root/Pinball").score))

var noirblanc = preload("res://elements/fond.tex")
var noirblanccache = preload("res://elements/cache.png")
var color = preload("res://elements/fond1.png")
var colorcache = preload("res://elements/cache2.png")
var rose = preload("res://elements/fond2.png")
var rosecache = preload("res://elements/cache3.png")
var cache2 = preload("res://elements/arrierecache.png")
var colorcache2 = preload("res://elements/arrierecache2.png")

func _on_noirblanc_button_up():
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/style/coloré").set_disabled(0)
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/style/noirblanc").set_disabled(1)
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/style/rose").set_disabled(0)
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/texture").set_texture(noirblanc)
	get_node("/root/Pinball/Fond").set_texture(noirblanc)
	get_node("/root/Pinball/cache").set_texture(noirblanccache)
	get_node("/root/Pinball/cacheArriere").set_texture(cache2)

func _on_color_button_up():
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/style/coloré").set_disabled(1)
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/style/noirblanc").set_disabled(0)
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/style/rose").set_disabled(0)
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/texture").set_texture(color)
	get_node("/root/Pinball/Fond").set_texture(color)
	get_node("/root/Pinball/cache").set_texture(colorcache)
	get_node("/root/Pinball/cacheArriere").set_texture(colorcache2)

func _on_rose_button_up():
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/style/coloré").set_disabled(0)
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/style/noirblanc").set_disabled(0)
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/style/rose").set_disabled(1)
	get_node("OptionsBackground/Options/TabContainer/Jeu/VBoxJeu/texture").set_texture(rose)
	get_node("/root/Pinball/Fond").set_texture(rose)
	get_node("/root/Pinball/cache").set_texture(rosecache)
	get_node("/root/Pinball/cacheArriere").set_texture(cache2)