extends Control

func _ready():
	$VBoxContainer/LoadButton.disabled = not GameData.has_save_file()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/CharacterCreation.tscn")

func _on_load_button_pressed():
	GameData.load_game()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
