extends Control

func _ready():

	$IntroPanel/VBoxContainer/IntroLabel.text = \
		"Welcome, " + GameData.player_name + ", to University Malaya.\n\n" + \
		"Congratulations on entering " + GameData.major + ".\n\n" + \
		"Your semester journey begins now..."

func _on_begin_button_pressed():
	get_tree().change_scene_to_file(
		"res://scenes/main.tscn"
	)
