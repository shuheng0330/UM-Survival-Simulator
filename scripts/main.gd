extends Node2D


var gpa: float = 3.0
var stress = 20
var energy = 80
var money = 100
var social = 50
var week = 1
var faculty_completed = false
var library_completed = false
var kolej_completed = false
var cafeteria_completed = false
var sports_completed = false
var club_completed = false
var major = ""
var exam_active = false

func _ready():
	print("Player Name:", GameData.player_name)
	print("Major:", GameData.major)
	print("Kolej:", GameData.kolej)
	major = GameData.major
	update_stats()

func update_stats():
	clamp_stats()
	$UI/StatsLabel.text = \
	"Week: " + str(week) + "\n" + \
	"GPA: %.2f\n" % gpa + \
	"Stress: " + str(stress) + "\n" + \
	"Energy: " + str(energy) + "\n" + \
	"Money: " + str(money) + "\n" + \
	"Social: " + str(social)
	check_game_over()
	
func trigger_random_event():
	var chance = randi_range(1, 100)

	if chance <= 40:
		show_random_event()
		
func clamp_stats():
	gpa = clamp(gpa, 0.0, 4.0)
	gpa = snapped(gpa, 0.01) # Keeps the decimals perfectly clean
	stress = clamp(stress, 0, 100)
	energy = clamp(energy, 0, 100)
	money = clamp(money, -50, 200)
	social = clamp(social, 0, 100)

func show_random_event():
	var event_id = randi_range(1, 5)

	match event_id:
		1:
			stress += 5
			energy -= 5
			show_message("Random Event:\nHeavy rain caused travel delay.\nStress +5, Energy -5")
		2:
			money += 10
			social += 5
			show_message("Random Event:\nFree food at kolej event!\nMoney +10, Social +5")
		3:
			money -= 15
			stress += 10
			show_message("Random Event:\nLaptop problem before class.\nMoney -15, Stress +10")
		4:
			gpa -= 0.2
			energy += 10
			show_message("Random Event:\nYou overslept morning class.\nGPA -0.2, Energy +10")
		5:
			stress += 10
			show_message("Random Event:\nGroup member did not reply.\nStress +10")
			
func show_message(message):
	$UI/EventPanel.visible = true
	$UI/EventPanel/VBoxContainer/EventLabel.text = message
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = false
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = false

func next_week():
	if week >= 14:
		show_ending()
		return

	week += 1
	faculty_completed = false
	library_completed = false
	kolej_completed = false
	cafeteria_completed = false
	sports_completed = false
	club_completed = false

	$UI/EventPanel.visible = false

	if week == 14:
		show_exam()
	else:
		trigger_random_event()

	update_stats()
	
func show_exam():
	exam_active = true
	$UI/EventPanel.visible = true
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true

	match major:
		"Software Engineering":
			$UI/EventPanel/VBoxContainer/EventLabel.text = "Final Exam - Software Engineering:\nWhat does SDLC stand for?"
			$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Software Development Life Cycle"
			$UI/EventPanel/VBoxContainer/DoLaterButton.text = "System Data Link Control"

		"Medicine":
			$UI/EventPanel/VBoxContainer/EventLabel.text = "Final Exam - Medicine:\nWhich organ pumps blood around the body?"
			$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Heart"
			$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Liver"

		"Business and Economics":
			$UI/EventPanel/VBoxContainer/EventLabel.text = "Final Exam - Business:\nWhat does SWOT analysis include?"
			$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Strengths, Weaknesses, Opportunities, Threats"
			$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Sales, Workload, Operations, Targets"

		"Law":
			$UI/EventPanel/VBoxContainer/EventLabel.text = "Final Exam - Law:\nWhat is a contract?"
			$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "A legally enforceable agreement"
			$UI/EventPanel/VBoxContainer/DoLaterButton.text = "A casual promise only"

		"Education":
			$UI/EventPanel/VBoxContainer/EventLabel.text = "Final Exam - Education:\nWhat is pedagogy?"
			$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "The method and practice of teaching"
			$UI/EventPanel/VBoxContainer/DoLaterButton.text = "A school building"

		_:
			$UI/EventPanel/VBoxContainer/EventLabel.text = "Final Exam:\nGeneral university knowledge question."
			$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Correct Answer"
			$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Wrong Answer"
	
func show_ending():
	$UI/EventPanel.visible = true
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = false
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = false

	if gpa >= 3.7 and stress <= 50:
		$UI/EventPanel/VBoxContainer/EventLabel.text = "Final Result:\nDean List Survivor!\nYou balanced study and wellbeing well."
	elif stress >= 80:
		$UI/EventPanel/VBoxContainer/EventLabel.text = "Final Result:\nBurnout Ending.\nYou studied hard, but stress became too high."
	elif gpa < 2.0:
		$UI/EventPanel/VBoxContainer/EventLabel.text = "Final Result:\nAcademic Probation.\nYou need better study planning next semester."
	else:
		$UI/EventPanel/VBoxContainer/EventLabel.text = "Final Result:\nBalanced Student.\nYou completed the semester with acceptable performance."
		
func check_game_over():
	if stress >= 100:
		show_message("Game Over:\nYour stress reached a dangerous level.\nYou need better balance next semester.")
		return true

	if energy <= 0:
		show_message("Game Over:\nYou are too exhausted to continue the semester.")
		return true

	if money <= -50:
		show_message("Game Over:\nYou ran into serious financial trouble.")
		return true

	if gpa <= 2.0:
		show_message("Game Over:\nYour academic performance dropped too low.")
		return true

	return false
	
func setup_kolej_event():
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel.visible = true

	$UI/EventPanel/VBoxContainer/EventLabel.text = \
	"Kolej Kediaman:\nYou returned to your room after a tiring day."

	$UI/EventPanel/VBoxContainer/StartEarlyButton.text = \
	"Sleep Early"

	$UI/EventPanel/VBoxContainer/DoLaterButton.text = \
	"Stay Up Gaming"
	
func setup_library_event():
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel.visible = true
	$UI/EventPanel/VBoxContainer/EventLabel.text = "Library:\nYou found a quiet study space."
	$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Study Here"
	$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Leave and Rest"
	
func setup_cafeteria_event():
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel.visible = true

	$UI/EventPanel/VBoxContainer/EventLabel.text = \
	"Cafeteria:\nYou feel hungry after class."

	$UI/EventPanel/VBoxContainer/StartEarlyButton.text = \
	"Buy Meal"

	$UI/EventPanel/VBoxContainer/DoLaterButton.text = \
	"Skip Meal"
	
func setup_sports_event():
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel.visible = true

	$UI/EventPanel/VBoxContainer/EventLabel.text = \
	"Sports Centre:\nYour friends invite you to exercise."

	$UI/EventPanel/VBoxContainer/StartEarlyButton.text = \
	"Play Badminton"

	$UI/EventPanel/VBoxContainer/DoLaterButton.text = \
	"Skip Exercise"
	
func setup_club_event():
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel.visible = true

	$UI/EventPanel/VBoxContainer/EventLabel.text = \
	"Club Room:\nThere is a club activity today."

	$UI/EventPanel/VBoxContainer/StartEarlyButton.text = \
	"Join Club Activity"

	$UI/EventPanel/VBoxContainer/DoLaterButton.text = \
	"Focus on Study Instead"

func setup_faculty_event():
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel.visible = true
	
	# Determine the text dynamically based on the player's major and the current week
	var event_text = ""
	
	match major:
		"Software Engineering":
			match week:
				1: event_text = "Orientation Week:\nMeet your programming lecturer."
				2: event_text = "Week 2:\nLearn basic programming concepts."
				3: event_text = "Week 3:\nProgramming assignment released."
				4: event_text = "Week 4:\nDatabase quiz announced."
				5: event_text = "Week 5:\nSystem design discussion."
				_: event_text = "Normal Software Engineering lecture week."

		"Medicine":
			match week:
				1: event_text = "Orientation Week:\nHospital introduction session."
				2: event_text = "Week 2:\nAnatomy lecture begins."
				3: event_text = "Week 3:\nAnatomy practical assignment released."
				4: event_text = "Week 4:\nMedical terminology quiz."
				5: event_text = "Week 5:\nClinical observation session."
				_: event_text = "Normal Medicine lecture week."

		"Business and Economics", "Business": # Added safety catch for variations in naming
			match week:
				1: event_text = "Orientation Week:\nMeet your business advisor."
				2: event_text = "Week 2:\nIntroduction to marketing."
				3: event_text = "Week 3:\nBusiness case study assigned."
				4: event_text = "Week 4:\nPresentation preparation week."
				5: event_text = "Week 5:\nEntrepreneurship workshop."
				_: event_text = "Normal Business lecture week."

		"Law":
			match week:
				1: event_text = "Orientation Week:\nFaculty legal briefing."
				2: event_text = "Week 2:\nConstitutional law lecture."
				3: event_text = "Week 3:\nCase analysis assignment released."
				4: event_text = "Week 4:\nMock court preparation."
				5: event_text = "Week 5:\nLegal ethics discussion."
				_: event_text = "Normal Law lecture week."

		"Education":
			match week:
				1: event_text = "Orientation Week:\nMeet your teaching mentor."
				2: event_text = "Week 2:\nIntroduction to pedagogy."
				3: event_text = "Week 3:\nTeaching reflection assignment."
				4: event_text = "Week 4:\nClassroom activity planning."
				5: event_text = "Week 5:\nSchool observation session."
				_: event_text = "Normal Education lecture week."

		_:
			event_text = "General university lecture week."

	# Apply the text to your UI element
	$UI/EventPanel/VBoxContainer/EventLabel.text = event_text

	# Configure the button action texts dynamically based on week contextual flow
	if week == 1:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Join Orientation"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Skip and Rest"
	elif week == 2:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Attend Lecture"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Skip Class"
	elif week == 3:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Start Early"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Do Later"
	elif week == 4:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Revise Tonight"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Relax First"
	elif week == 5:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Study Seriously"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Study Last Minute"
	else:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Focus in Class"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Just Attend"

func _on_faculty_area_body_entered(body):
	if body.name == "Player" and not faculty_completed:
		setup_faculty_event()

func _on_faculty_area_body_exited(body):
	if body.name == "Player":
		$UI/EventPanel.visible = false

func _on_start_early_button_pressed():
	if $UI/EventPanel/VBoxContainer/StartEarlyButton.text == "Join Club Activity":
		social += 15
		stress -= 8
		energy -= 8
		gpa -= 0.1
		club_completed = true
		$UI/EventPanel.visible = false
		update_stats()
		return
	
	if $UI/EventPanel/VBoxContainer/StartEarlyButton.text == "Play Badminton":
		stress -= 12
		energy -= 8
		social += 8
		sports_completed = true
		$UI/EventPanel.visible = false
		update_stats()
		return
		
	if $UI/EventPanel/VBoxContainer/StartEarlyButton.text == "Buy Meal":
		energy += 15
		money -= 10
		stress -= 3
		cafeteria_completed = true
		$UI/EventPanel.visible = false
		update_stats()
		return
	
	if exam_active:
		gpa += 0.4
		exam_active = false
		$UI/EventPanel.visible = false
		show_ending()
		update_stats()
		return
	if $UI/EventPanel/VBoxContainer/StartEarlyButton.text == "Sleep Early":
		energy += 20
		stress -= 10
		kolej_completed = true
		$UI/EventPanel.visible = false
		update_stats()
		return
	# 1. Add this check at the very top of the function
	if $UI/EventPanel/VBoxContainer/StartEarlyButton.text == "Study Here":
		gpa += 0.3
		energy -= 10
		stress += 3
		library_completed = true
		$UI/EventPanel.visible = false
		update_stats()
		return # This stops the rest of the function from running

	# 2. Your original code stays exactly the same underneath
	match week:
		1:
			social += 10
			energy -= 5
		2:
			gpa += 0.2
			energy -= 5
		3:
			gpa += 0.3
			stress += 5
			energy -= 10
		4:
			gpa += 0.2
			stress += 5
			energy -= 8
		5:
			gpa += 0.4
			stress += 10
			energy -= 15
		_:
			gpa += 0.1
			energy -= 5
	
	faculty_completed = true
	$UI/EventPanel.visible = false
	update_stats()

func _on_do_later_button_pressed():
	if $UI/EventPanel/VBoxContainer/DoLaterButton.text == "Focus on Study Instead":
		gpa += 0.2
		social -= 5
		stress += 3
		club_completed = true
		$UI/EventPanel.visible = false
		update_stats()
		return
		
	if $UI/EventPanel/VBoxContainer/DoLaterButton.text == "Skip Exercise":
		stress += 5
		energy += 5
		social -= 3
		sports_completed = true
		$UI/EventPanel.visible = false
		update_stats()
		return
		
	if $UI/EventPanel/VBoxContainer/DoLaterButton.text == "Skip Meal":
		energy -= 10
		stress += 5
		cafeteria_completed = true
		$UI/EventPanel.visible = false
		update_stats()
		return
	
	if exam_active:
		stress += 5
		gpa -= 0.3
		exam_active = false
		$UI/EventPanel.visible = false
		show_ending()
		update_stats()
		return
	if $UI/EventPanel/VBoxContainer/DoLaterButton.text == "Stay Up Gaming":
		stress -= 10
		energy -= 5
		gpa -= 0.1
		kolej_completed = true
		$UI/EventPanel.visible = false
		update_stats()
		return
	if $UI/EventPanel/VBoxContainer/DoLaterButton.text == "Leave and Rest":
		energy += 10
		gpa -= 0.1
		library_completed = true
		$UI/EventPanel.visible = false
		update_stats()
		return
	match week:
		1:
			energy += 10
			social -= 5
		2:
			gpa -= 0.2
			stress += 5
		3:
			gpa -= 0.2
			stress += 10
		4:
			gpa -= 0.3
			stress += 10
		5:
			gpa -= 0.4
			stress += 15
		_:
			gpa -= 0.1
			stress += 3
	
	faculty_completed = true
	$UI/EventPanel.visible = false
	update_stats()

func _on_next_week_button_pressed():
	next_week()


func _on_library_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not library_completed:
		setup_library_event() # Replace with function body.


func _on_library_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$UI/EventPanel.visible = false # Replace with function body.


func _on_kolej_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not kolej_completed:
		setup_kolej_event() # Replace with function body.


func _on_kolej_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$UI/EventPanel.visible = false # Replace with function body.


func _on_cafeteria_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not cafeteria_completed:
		setup_cafeteria_event() # Replace with function body.


func _on_cafeteria_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$UI/EventPanel.visible = false # Replace with function body.


func _on_sports_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not sports_completed:
		setup_sports_event() # Replace with function body.


func _on_sports_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$UI/EventPanel.visible = false # Replace with function body.


func _on_club_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not club_completed:
		setup_club_event() # Replace with function body.


func _on_club_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$UI/EventPanel.visible = false # Replace with function body.
