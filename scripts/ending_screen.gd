extends Control

func _ready():
	match GameData.ending_type:
		"gym_freak":
			$ContentPanel/VBoxContainer/ResultTitle.text = "Gym Freak!"
			$ContentPanel/VBoxContainer/FlavorText.text = "You hit the Sports Centre almost every week!\nYour dedication to fitness made you a campus legend."
		"celebrity":
			$ContentPanel/VBoxContainer/ResultTitle.text = "Campus Celebrity!"
			$ContentPanel/VBoxContainer/FlavorText.text = "Your social life was unmatched.\nEveryone on campus knows your name!"
		"millionaire":
			$ContentPanel/VBoxContainer/ResultTitle.text = "Millionaire Student!"
			$ContentPanel/VBoxContainer/FlavorText.text = "You managed your finances brilliantly.\nRicher than most graduates at the end of semester!"
		"dean_list":
			$ContentPanel/VBoxContainer/ResultTitle.text = "Dean List Survivor!"
			$ContentPanel/VBoxContainer/FlavorText.text = "You balanced study and wellbeing perfectly.\nCongratulations on an outstanding semester!"
		"burnout":
			$ContentPanel/VBoxContainer/ResultTitle.text = "Burnout Ending"
			$ContentPanel/VBoxContainer/FlavorText.text = "You studied hard, but stress took its toll.\nRemember to take breaks next time."
		"probation":
			$ContentPanel/VBoxContainer/ResultTitle.text = "Academic Probation"
			$ContentPanel/VBoxContainer/FlavorText.text = "Your grades dropped too low.\nBetter planning is needed next semester."
		_:
			$ContentPanel/VBoxContainer/ResultTitle.text = "Balanced Student"
			$ContentPanel/VBoxContainer/FlavorText.text = "You completed the semester with acceptable performance.\nNot bad — but you can do better!"

	$ContentPanel/VBoxContainer/StatsLabel.text = (
		"Final Stats\n" +
		"GPA:     %.2f\n" % GameData.final_gpa +
		"Stress:  %d\n" % GameData.final_stress +
		"Energy:  %d\n" % GameData.final_energy +
		"Money:   %d\n" % GameData.final_money +
		"Social:  %d\n" % GameData.final_social +
		"Exam:    %d/5" % GameData.exam_score
	)
	GameData.delete_save()

func _on_play_again_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
