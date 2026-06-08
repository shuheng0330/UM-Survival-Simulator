extends Control

func _ready():
	AudioManager.play_music()
	$VBoxContainer/LoadButton.disabled = not GameData.has_save_file()

func _on_play_button_pressed():
	AudioManager.play_sfx("btn_click")
	get_tree().change_scene_to_file("res://scenes/CharacterCreation.tscn")

func _on_how_to_play_button_pressed():
	AudioManager.play_sfx("btn_click")
	get_tree().change_scene_to_file("res://scenes/HowToPlay.tscn")

func _on_load_button_pressed():
	AudioManager.play_sfx("btn_click")
	GameData.load_game()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_button_pressed():
	AudioManager.play_sfx("btn_click")
	get_tree().quit()
