extends Control

func _on_back_button_pressed():
	AudioManager.play_sfx("btn_click")
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
