extends Control

func _ready():
	_style_popup($FormPanel/VBoxContainer/MajorOption.get_popup())
	_style_popup($FormPanel/VBoxContainer/KolejOption.get_popup())
	for err in [$FormPanel/VBoxContainer/NameError,
				$FormPanel/VBoxContainer/MajorError,
				$FormPanel/VBoxContainer/KolejError]:
		err.add_theme_color_override("font_color", Color(1.0, 0.35, 0.35, 1.0))
		err.add_theme_font_size_override("font_size", 12)

func _style_popup(popup: PopupMenu) -> void:
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.10, 0.10, 0.20, 0.97)
	panel_style.corner_radius_top_left = 8
	panel_style.corner_radius_top_right = 8
	panel_style.corner_radius_bottom_right = 8
	panel_style.corner_radius_bottom_left = 8
	panel_style.border_width_left = 1
	panel_style.border_width_top = 1
	panel_style.border_width_right = 1
	panel_style.border_width_bottom = 1
	panel_style.border_color = Color(0.25, 0.25, 0.4, 1.0)
	panel_style.content_margin_left = 4.0
	panel_style.content_margin_top = 4.0
	panel_style.content_margin_right = 4.0
	panel_style.content_margin_bottom = 4.0
	popup.add_theme_stylebox_override("panel", panel_style)

	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = Color(0.22, 0.15, 0.38, 1.0)
	hover_style.corner_radius_top_left = 6
	hover_style.corner_radius_top_right = 6
	hover_style.corner_radius_bottom_right = 6
	hover_style.corner_radius_bottom_left = 6
	hover_style.content_margin_left = 8.0
	hover_style.content_margin_top = 4.0
	hover_style.content_margin_right = 8.0
	hover_style.content_margin_bottom = 4.0
	popup.add_theme_stylebox_override("hover", hover_style)

	popup.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	popup.add_theme_color_override("font_hover_color", Color(0.79, 0.58, 0.16, 1.0))
	popup.add_theme_constant_override("v_separation", 6)
	popup.add_theme_constant_override("item_start_padding", 10)
	popup.add_theme_constant_override("item_end_padding", 10)

func _on_start_button_pressed():
	var valid = true

	if $FormPanel/VBoxContainer/NameInput.text.strip_edges().is_empty():
		$FormPanel/VBoxContainer/NameError.visible = true
		valid = false
	else:
		$FormPanel/VBoxContainer/NameError.visible = false

	if $FormPanel/VBoxContainer/MajorOption.selected == -1:
		$FormPanel/VBoxContainer/MajorError.visible = true
		valid = false
	else:
		$FormPanel/VBoxContainer/MajorError.visible = false

	if $FormPanel/VBoxContainer/KolejOption.selected == -1:
		$FormPanel/VBoxContainer/KolejError.visible = true
		valid = false
	else:
		$FormPanel/VBoxContainer/KolejError.visible = false

	if not valid:
		return

	GameData.player_name = $FormPanel/VBoxContainer/NameInput.text.strip_edges()
	GameData.age = int($FormPanel/VBoxContainer/AgeInput.value)
	GameData.major = $FormPanel/VBoxContainer/MajorOption.get_item_text(
		$FormPanel/VBoxContainer/MajorOption.selected
	)
	GameData.kolej = $FormPanel/VBoxContainer/KolejOption.get_item_text(
		$FormPanel/VBoxContainer/KolejOption.selected
	)
	AudioManager.play_sfx("btn_click")
	get_tree().change_scene_to_file("res://scenes/IntroScene.tscn")
