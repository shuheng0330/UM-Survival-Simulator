extends Control

func _ready():
	$IntroPanel/VBoxContainer/WelcomeTitle.text = \
		"Welcome, " + GameData.player_name + "!"
	$IntroPanel/VBoxContainer/IntroLabel.text = \
		"Congratulations on entering " + GameData.major + ".\n\n" + \
		"Your semester journey begins now. Make wise choices,\n" + \
		"manage your time well, and survive the semester!"

func _on_begin_button_pressed():
	AudioManager.play_sfx("btn_click")
	get_tree().change_scene_to_file("res://scenes/main.tscn")
