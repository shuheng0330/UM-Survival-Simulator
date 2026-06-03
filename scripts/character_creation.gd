extends Control

func _on_start_button_pressed():

	GameData.player_name = $FormPanel/VBoxContainer/NameInput.text

	GameData.age = int(
		$FormPanel/VBoxContainer/AgeInput.value
	)

	GameData.major = \
		$FormPanel/VBoxContainer/MajorOption.get_item_text(
			$FormPanel/VBoxContainer/MajorOption.selected
		)

	GameData.kolej = \
		$FormPanel/VBoxContainer/KolejOption.get_item_text(
			$FormPanel/VBoxContainer/KolejOption.selected
		)

	get_tree().change_scene_to_file(
	"res://scenes/IntroScene.tscn"
	)
