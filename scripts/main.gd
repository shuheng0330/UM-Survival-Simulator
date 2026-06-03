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
var active_event := ""
var exam_question_index: int = 0
var exam_score: int = 0
var exam_questions: Array = []
var sports_visit_count: int = 0

func _ready():
	print("Player Name:", GameData.player_name)
	print("Major:", GameData.major)
	print("Kolej:", GameData.kolej)
	major = GameData.major
	_setup_ui_styles()
	if GameData.is_loading_save:
		gpa = GameData.save_gpa
		stress = GameData.save_stress
		energy = GameData.save_energy
		money = GameData.save_money
		social = GameData.save_social
		week = GameData.save_week
		faculty_completed = GameData.save_faculty_completed
		library_completed = GameData.save_library_completed
		kolej_completed = GameData.save_kolej_completed
		cafeteria_completed = GameData.save_cafeteria_completed
		sports_completed = GameData.save_sports_completed
		club_completed = GameData.save_club_completed
		sports_visit_count = GameData.save_sports_visit_count
		GameData.is_loading_save = false
	update_stats()

func update_stats():
	clamp_stats()
	$UI/WeekPanel/WeekLabel.text = "Week %d" % week
	$UI/StatsPanel/StatsLabel.text = \
		"🎓 GPA:    %.2f\n" % gpa + \
		"😓 Stress: %d\n" % stress + \
		"⚡ Energy: %d\n" % energy + \
		"💰 Money:  RM%d\n" % money + \
		"👥 Social: %d" % social
	$UI/SemProgressBar.offset_right = (float(week) / 14.0) * 1152.0
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
	var event_id = randi_range(1, 10)

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
		6:
			energy += 10
			social += 5
			show_message("Random Event:\nLecturer cancelled class today!\nEnergy +10, Social +5")
		7:
			stress += 15
			show_message("Random Event:\nOnline portal crashed before submission deadline.\nStress +15")
		8:
			money += 20
			show_message("Random Event:\nYou found RM20 in an old bag.\nMoney +20")
		9:
			stress += 5
			energy -= 5
			show_message("Random Event:\nPower outage at kolej tonight.\nStress +5, Energy -5")
		10:
			gpa += 0.1
			social += 5
			show_message("Random Event:\nA classmate shared excellent revision notes.\nGPA +0.1, Social +5")
			
func show_message(message):
	active_event = ""
	$UI/EventPanel.visible = true
	_set_event_text(message)
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = false
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = false
	$UI/EventPanel/VBoxContainer/OkButton.visible = true
	$UI/EventPanel/VBoxContainer/ClubOption3Button.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption4Button.visible = false

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
	active_event = "exam"
	exam_question_index = 0
	exam_score = 0
	build_exam_questions()
	show_exam_question()

func build_exam_questions():
	exam_questions.clear()
	match major:
		"Software Engineering":
			exam_questions = [
				{"q": "What does SDLC stand for?", "c": "Software Development Life Cycle", "w": "System Data Link Control"},
				{"q": "Which of these is an OOP concept?", "c": "Encapsulation", "w": "Compilation"},
				{"q": "What does SQL stand for?", "c": "Structured Query Language", "w": "Simple Queue Language"},
				{"q": "Which sorting algorithm has O(n log n) average complexity?", "c": "Merge Sort", "w": "Bubble Sort"},
				{"q": "What is a software 'bug'?", "c": "An error or flaw in a program", "w": "A virus in the system"},
			]
		"Medicine":
			exam_questions = [
				{"q": "Which organ pumps blood around the body?", "c": "Heart", "w": "Liver"},
				{"q": "What does DNA stand for?", "c": "Deoxyribonucleic Acid", "w": "Dynamic Nuclear Acid"},
				{"q": "Which blood type is the universal donor?", "c": "O Negative", "w": "AB Positive"},
				{"q": "What is the main function of the kidneys?", "c": "Filter blood and produce urine", "w": "Produce insulin"},
				{"q": "What does the term 'hypertension' refer to?", "c": "High blood pressure", "w": "Low blood sugar"},
			]
		"Business and Economics", "Business":
			exam_questions = [
				{"q": "What does SWOT analysis include?", "c": "Strengths, Weaknesses, Opportunities, Threats", "w": "Sales, Workload, Operations, Targets"},
				{"q": "What does GDP stand for?", "c": "Gross Domestic Product", "w": "General Development Plan"},
				{"q": "What is the purpose of a balance sheet?", "c": "Show assets, liabilities and equity", "w": "Track daily sales performance"},
				{"q": "What is inflation?", "c": "A rise in the general price level", "w": "A fall in the unemployment rate"},
				{"q": "What does the marketing mix refer to?", "c": "Product, Price, Place, Promotion", "w": "Market, Margins, Media, Money"},
			]
		"Law":
			exam_questions = [
				{"q": "What is a contract?", "c": "A legally enforceable agreement", "w": "A casual promise only"},
				{"q": "What is a 'tort'?", "c": "A civil wrong causing harm to another", "w": "A criminal offence against the state"},
				{"q": "What does habeas corpus protect?", "c": "Right to be brought before a court", "w": "Right to own property"},
				{"q": "What is the purpose of criminal law?", "c": "Punish those who harm society", "w": "Resolve disputes between individuals"},
				{"q": "What is 'precedent' in law?", "c": "A prior case used as a rule for future cases", "w": "A written law passed by Parliament"},
			]
		"Education":
			exam_questions = [
				{"q": "What is pedagogy?", "c": "The method and practice of teaching", "w": "A school building"},
				{"q": "What is Bloom's Taxonomy?", "c": "A framework for classifying learning objectives", "w": "A school grading system"},
				{"q": "What does IEP stand for?", "c": "Individualized Education Program", "w": "Integrated Educational Policy"},
				{"q": "What is formative assessment?", "c": "Ongoing assessment to monitor learning progress", "w": "Final exam at end of semester"},
				{"q": "Which approach involves student-led inquiry?", "c": "Constructivism", "w": "Direct instruction"},
			]
		_:
			exam_questions = [
				{"q": "Question 1: General knowledge.", "c": "Correct Answer", "w": "Wrong Answer"},
				{"q": "Question 2: General knowledge.", "c": "Correct Answer", "w": "Wrong Answer"},
				{"q": "Question 3: General knowledge.", "c": "Correct Answer", "w": "Wrong Answer"},
				{"q": "Question 4: General knowledge.", "c": "Correct Answer", "w": "Wrong Answer"},
				{"q": "Question 5: General knowledge.", "c": "Correct Answer", "w": "Wrong Answer"},
			]

func show_exam_question():
	var q = exam_questions[exam_question_index]
	_set_event_text("Final Exam (Question %d/5):\n%s" % [exam_question_index + 1, q["q"]])
	$UI/EventPanel/VBoxContainer/StartEarlyButton.text = q["c"]
	$UI/EventPanel/VBoxContainer/DoLaterButton.text = q["w"]
	$UI/EventPanel.visible = true
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel/VBoxContainer/OkButton.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption3Button.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption4Button.visible = false

func apply_exam_gpa():
	match exam_score:
		5: gpa += 0.5
		4: gpa += 0.3
		3: gpa += 0.1
		2: gpa -= 0.1
		1: gpa -= 0.2
		_: gpa -= 0.4
	GameData.exam_score = exam_score
	clamp_stats()
	
func show_ending():
	GameData.final_gpa = gpa
	GameData.final_stress = stress
	GameData.final_energy = energy
	GameData.final_money = money
	GameData.final_social = social

	if sports_visit_count >= 8:
		GameData.ending_type = "gym_freak"
	elif social > 90:
		GameData.ending_type = "celebrity"
	elif money > 150:
		GameData.ending_type = "millionaire"
	elif gpa >= 3.7 and stress <= 50:
		GameData.ending_type = "dean_list"
	elif stress >= 80:
		GameData.ending_type = "burnout"
	elif gpa < 2.0:
		GameData.ending_type = "probation"
	else:
		GameData.ending_type = "balanced"

	get_tree().change_scene_to_file("res://scenes/EndingScreen.tscn")
		
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
	active_event = "kolej"
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel/VBoxContainer/OkButton.visible = false
	$UI/EventPanel.visible = true

	_set_event_text("Kolej Kediaman:\nYou returned to your room after a tiring day.")
	$UI/EventPanel/VBoxContainer/ClubOption3Button.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption4Button.visible = false

	$UI/EventPanel/VBoxContainer/StartEarlyButton.text = \
	"Sleep Early"

	$UI/EventPanel/VBoxContainer/DoLaterButton.text = \
	"Stay Up Gaming"
	
func setup_library_event():
	active_event = "library"
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel/VBoxContainer/OkButton.visible = false
	$UI/EventPanel.visible = true
	_set_event_text("Library:\nYou found a quiet study space.")
	$UI/EventPanel/VBoxContainer/ClubOption3Button.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption4Button.visible = false
	$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Study Here"
	$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Leave and Rest"
	
func setup_cafeteria_event():
	active_event = "cafeteria"
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel/VBoxContainer/OkButton.visible = false
	$UI/EventPanel.visible = true

	_set_event_text("Cafeteria:\nYou feel hungry after class.")
	$UI/EventPanel/VBoxContainer/ClubOption3Button.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption4Button.visible = false

	$UI/EventPanel/VBoxContainer/StartEarlyButton.text = \
	"Buy Meal"

	$UI/EventPanel/VBoxContainer/DoLaterButton.text = \
	"Skip Meal"
	
func setup_sports_event():
	active_event = "sports"
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel/VBoxContainer/OkButton.visible = false
	$UI/EventPanel.visible = true

	var event_text = ""
	var join_text = ""

	if week <= 3:
		event_text = "Sports Centre:\nA morning jog around campus would do you good."
		join_text = "Go for a Jog"
	elif week <= 6:
		event_text = "Sports Centre:\nThe gym is open for a workout session."
		join_text = "Hit the Gym"
	elif week <= 9:
		event_text = "Sports Centre:\nThe swimming pool is free this afternoon."
		join_text = "Swim Some Laps"
	else:
		event_text = "Sports Centre:\nA yoga and stretching class is on today."
		join_text = "Join Yoga Class"

	_set_event_text(event_text)
	$UI/EventPanel/VBoxContainer/ClubOption3Button.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption4Button.visible = false
	$UI/EventPanel/VBoxContainer/StartEarlyButton.text = join_text
	$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Skip Exercise"
	
func setup_club_event():
	active_event = "club"
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel/VBoxContainer/OkButton.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption3Button.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption4Button.visible = false
	$UI/EventPanel.visible = true

	if week == 1:
		active_event = "club_select"
		$UI/EventPanel/VBoxContainer/ClubOption3Button.visible = true
		$UI/EventPanel/VBoxContainer/ClubOption4Button.visible = true
		_set_event_text("Club Room:\nChoose a club to join for the semester!")
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Badminton Club"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Board Game Club"
		$UI/EventPanel/VBoxContainer/ClubOption3Button.text = "Basketball Club"
		$UI/EventPanel/VBoxContainer/ClubOption4Button.text = "Singing Club"
	else:
		var club = GameData.selected_club
		var event_text = ""
		var join_text = "Join Club Activity"

		if club == "":
			event_text = "Club Room:\nThere is a club activity today."
		elif week <= 4:
			match club:
				"Badminton Club": event_text = "Badminton Club:\nWeekly training session at the sports hall."
				"Board Game Club": event_text = "Board Game Club:\nWeekly game night session."
				"Basketball Club": event_text = "Basketball Club:\nTraining drills at the court."
				"Singing Club": event_text = "Singing Club:\nVocal practice session with the group."
		elif week <= 8:
			match club:
				"Badminton Club": event_text = "Badminton Club:\nInter-faculty tournament coming up!"
				"Board Game Club": event_text = "Board Game Club:\nClub tournament event this week."
				"Basketball Club": event_text = "Basketball Club:\nFriendly match against another faculty."
				"Singing Club": event_text = "Singing Club:\nPreparing for the mid-semester showcase."
		else:
			match club:
				"Badminton Club": event_text = "Badminton Club:\nFinal practice before semester ends."
				"Board Game Club": event_text = "Board Game Club:\nEnd-of-semester board game marathon."
				"Basketball Club": event_text = "Basketball Club:\nFinal season game this week."
				"Singing Club": event_text = "Singing Club:\nFinal rehearsal before semester concert."

		match club:
			"Badminton Club": join_text = "Join Training"
			"Board Game Club": join_text = "Join Game Night"
			"Basketball Club": join_text = "Join Practice"
			"Singing Club": join_text = "Join Rehearsal"

		_set_event_text(event_text)
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = join_text
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Focus on Study Instead"

func setup_faculty_event():
	active_event = "faculty"
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel/VBoxContainer/OkButton.visible = false
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
				6: event_text = "Week 6:\nCoding test on algorithms announced."
				7: event_text = "Week 7:\nSoftware requirements document due."
				8: event_text = "Week 8:\nMid-term exam on data structures."
				9: event_text = "Week 9:\nCode review session with your lecturer."
				10: event_text = "Week 10:\nGroup project system design sprint."
				11: event_text = "Week 11:\nDebugging marathon for group project."
				12: event_text = "Week 12:\nSoftware demo day - final project."
				13: event_text = "Week 13:\nRevision week - review past papers."
				_: event_text = "Normal Software Engineering lecture week."

		"Medicine":
			match week:
				1: event_text = "Orientation Week:\nHospital introduction session."
				2: event_text = "Week 2:\nAnatomy lecture begins."
				3: event_text = "Week 3:\nAnatomy practical assignment released."
				4: event_text = "Week 4:\nMedical terminology quiz."
				5: event_text = "Week 5:\nClinical observation session."
				6: event_text = "Week 6:\nAnatomy lab dissection session."
				7: event_text = "Week 7:\nOSCE practical skills assessment."
				8: event_text = "Week 8:\nMid-term exam - pathology paper."
				9: event_text = "Week 9:\nHospital ward rounds observation."
				10: event_text = "Week 10:\nGroup clinical case presentation assigned."
				11: event_text = "Week 11:\nCase study presentation rehearsal."
				12: event_text = "Week 12:\nFinal lab report submission."
				13: event_text = "Week 13:\nRevision week - review clinical notes."
				_: event_text = "Normal Medicine lecture week."

		"Business and Economics", "Business": # Added safety catch for variations in naming
			match week:
				1: event_text = "Orientation Week:\nMeet your business advisor."
				2: event_text = "Week 2:\nIntroduction to marketing."
				3: event_text = "Week 3:\nBusiness case study assigned."
				4: event_text = "Week 4:\nPresentation preparation week."
				5: event_text = "Week 5:\nEntrepreneurship workshop."
				6: event_text = "Week 6:\nMarket research assignment released."
				7: event_text = "Week 7:\nFinancial report submission due."
				8: event_text = "Week 8:\nMid-term exam - microeconomics."
				9: event_text = "Week 9:\nGuest lecturer from the industry."
				10: event_text = "Week 10:\nGroup business plan kickoff."
				11: event_text = "Week 11:\nBusiness plan pitch rehearsal."
				12: event_text = "Week 12:\nFinal business plan presentation."
				13: event_text = "Week 13:\nRevision week - review case studies."
				_: event_text = "Normal Business lecture week."

		"Law":
			match week:
				1: event_text = "Orientation Week:\nFaculty legal briefing."
				2: event_text = "Week 2:\nConstitutional law lecture."
				3: event_text = "Week 3:\nCase analysis assignment released."
				4: event_text = "Week 4:\nMock court preparation."
				5: event_text = "Week 5:\nLegal ethics discussion."
				6: event_text = "Week 6:\nMoot court preparation begins."
				7: event_text = "Week 7:\nLegal essay submission due."
				8: event_text = "Week 8:\nMid-term exam - contract law."
				9: event_text = "Week 9:\nCourt visit observation day."
				10: event_text = "Week 10:\nGroup legal research project begins."
				11: event_text = "Week 11:\nLegal argument rehearsal session."
				12: event_text = "Week 12:\nFinal legal brief submission."
				13: event_text = "Week 13:\nRevision week - landmark case review."
				_: event_text = "Normal Law lecture week."

		"Education":
			match week:
				1: event_text = "Orientation Week:\nMeet your teaching mentor."
				2: event_text = "Week 2:\nIntroduction to pedagogy."
				3: event_text = "Week 3:\nTeaching reflection assignment."
				4: event_text = "Week 4:\nClassroom activity planning."
				5: event_text = "Week 5:\nSchool observation session."
				6: event_text = "Week 6:\nTeaching practicum planning begins."
				7: event_text = "Week 7:\nLesson plan submission due."
				8: event_text = "Week 8:\nMid-term exam - educational psychology."
				9: event_text = "Week 9:\nSchool observation report due."
				10: event_text = "Week 10:\nGroup curriculum design project."
				11: event_text = "Week 11:\nMock teaching session scheduled."
				12: event_text = "Week 12:\nFinal teaching portfolio submission."
				13: event_text = "Week 13:\nRevision week - review teaching theories."
				_: event_text = "Normal Education lecture week."

		_:
			event_text = "General university lecture week."

	# Apply the text to your UI element
	_set_event_text(event_text)
	$UI/EventPanel/VBoxContainer/ClubOption3Button.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption4Button.visible = false

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
	elif week == 6:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Work on Assignment"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Put It Off"
	elif week == 7:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Submit on Time"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Rush It"
	elif week == 8:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Revise Hard"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Wing the Exam"
	elif week == 9:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Stay Engaged"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Slack Off"
	elif week == 10:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Lead Your Group"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Free Ride"
	elif week == 11:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Push Through"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Give Up"
	elif week == 12:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Submit Best Work"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Rush Submission"
	elif week == 13:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Revise Intensively"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Rest Instead"
	else:
		$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Focus in Class"
		$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Just Attend"

func _on_faculty_area_body_entered(body):
	if body.name == "Player" and not faculty_completed:
		setup_faculty_event()

func _on_faculty_area_body_exited(body):
	if body.name == "Player":
		active_event = ""
		$UI/EventPanel.visible = false

func _on_start_early_button_pressed():
	if active_event == "exit_prompt":
		GameData.save_gpa = gpa
		GameData.save_stress = stress
		GameData.save_energy = energy
		GameData.save_money = money
		GameData.save_social = social
		GameData.save_week = week
		GameData.save_faculty_completed = faculty_completed
		GameData.save_library_completed = library_completed
		GameData.save_kolej_completed = kolej_completed
		GameData.save_cafeteria_completed = cafeteria_completed
		GameData.save_sports_completed = sports_completed
		GameData.save_club_completed = club_completed
		GameData.save_sports_visit_count = sports_visit_count
		GameData.save_game()
		active_event = ""
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
		return

	if active_event == "club_select":
		GameData.selected_club = "Badminton Club"
		_finish_club_selection()
		return

	if active_event == "club":
		social += 15
		stress -= 8
		energy -= 8
		gpa -= 0.1
		club_completed = true
		active_event = ""
		$UI/EventPanel.visible = false
		update_stats()
		return

	if active_event == "sports":
		stress -= 12
		energy -= 8
		social += 8
		sports_visit_count += 1
		sports_completed = true
		active_event = ""
		$UI/EventPanel.visible = false
		update_stats()
		return

	if active_event == "cafeteria":
		energy += 15
		money -= 10
		stress -= 3
		cafeteria_completed = true
		active_event = ""
		$UI/EventPanel.visible = false
		update_stats()
		return

	if active_event == "exam":
		exam_score += 1
		exam_question_index += 1
		if exam_question_index >= 5:
			apply_exam_gpa()
			exam_active = false
			active_event = ""
			update_stats()
			show_ending()
		else:
			show_exam_question()
			update_stats()
		return

	if active_event == "kolej":
		energy += 20
		stress -= 10
		kolej_completed = true
		active_event = ""
		$UI/EventPanel.visible = false
		update_stats()
		return

	if active_event == "library":
		gpa += 0.3
		energy -= 10
		stress += 3
		library_completed = true
		active_event = ""
		$UI/EventPanel.visible = false
		update_stats()
		return

	if active_event == "faculty":
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
			6:
				gpa += 0.15
				energy -= 5
			7:
				gpa += 0.2
				stress += 5
				energy -= 8
			8:
				gpa += 0.4
				stress += 15
				energy -= 20
			9:
				gpa += 0.1
				stress -= 5
				energy -= 3
			10:
				gpa += 0.1
				social += 5
				energy -= 8
			11:
				gpa += 0.2
				stress += 8
				energy -= 12
			12:
				gpa += 0.3
				stress += 10
				energy -= 15
			13:
				gpa += 0.3
				stress += 10
				energy -= 15
			_:
				gpa += 0.1
				energy -= 5
		faculty_completed = true
		active_event = ""
		$UI/EventPanel.visible = false
		update_stats()

func _on_do_later_button_pressed():
	if active_event == "exit_prompt":
		active_event = ""
		GameData.delete_save()
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
		return

	if active_event == "club_select":
		GameData.selected_club = "Board Game Club"
		_finish_club_selection()
		return

	if active_event == "club":
		gpa += 0.2
		social -= 5
		stress += 3
		club_completed = true
		active_event = ""
		$UI/EventPanel.visible = false
		update_stats()
		return

	if active_event == "sports":
		stress += 5
		energy += 5
		social -= 3
		sports_completed = true
		active_event = ""
		$UI/EventPanel.visible = false
		update_stats()
		return

	if active_event == "cafeteria":
		energy -= 10
		stress += 5
		cafeteria_completed = true
		active_event = ""
		$UI/EventPanel.visible = false
		update_stats()
		return

	if active_event == "exam":
		exam_question_index += 1
		if exam_question_index >= 5:
			apply_exam_gpa()
			exam_active = false
			active_event = ""
			update_stats()
			show_ending()
		else:
			show_exam_question()
			update_stats()
		return

	if active_event == "kolej":
		stress -= 10
		energy -= 5
		gpa -= 0.1
		kolej_completed = true
		active_event = ""
		$UI/EventPanel.visible = false
		update_stats()
		return

	if active_event == "library":
		energy += 10
		gpa -= 0.1
		library_completed = true
		active_event = ""
		$UI/EventPanel.visible = false
		update_stats()
		return

	if active_event == "faculty":
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
			6:
				gpa -= 0.1
				stress += 3
			7:
				gpa -= 0.2
				stress += 8
			8:
				gpa -= 0.4
				stress += 10
			9:
				energy += 10
				stress -= 5
			10:
				gpa -= 0.1
				social -= 5
				stress += 3
			11:
				gpa -= 0.2
				stress += 10
			12:
				gpa -= 0.3
				stress += 12
			13:
				gpa -= 0.3
				stress += 8
			_:
				gpa -= 0.1
				stress += 3
		faculty_completed = true
		active_event = ""
		$UI/EventPanel.visible = false
		update_stats()

func _on_next_week_button_pressed():
	next_week()

func _on_ok_button_pressed():
	$UI/EventPanel.visible = false

func show_exit_prompt():
	active_event = "exit_prompt"
	_set_event_text("Exit Game:\nDo you want to save your progress before exiting?")
	$UI/EventPanel/VBoxContainer/StartEarlyButton.text = "Save & Exit"
	$UI/EventPanel/VBoxContainer/StartEarlyButton.visible = true
	$UI/EventPanel/VBoxContainer/DoLaterButton.text = "Exit Without Saving"
	$UI/EventPanel/VBoxContainer/DoLaterButton.visible = true
	$UI/EventPanel/VBoxContainer/OkButton.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption3Button.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption4Button.visible = false
	$UI/EventPanel.visible = true

func _on_exit_button_pressed():
	show_exit_prompt()

func _on_dpad_up_button_down():    Input.action_press("move_up")
func _on_dpad_up_button_up():      Input.action_release("move_up")
func _on_dpad_down_button_down():  Input.action_press("move_down")
func _on_dpad_down_button_up():    Input.action_release("move_down")
func _on_dpad_left_button_down():  Input.action_press("move_left")
func _on_dpad_left_button_up():    Input.action_release("move_left")
func _on_dpad_right_button_down(): Input.action_press("move_right")
func _on_dpad_right_button_up():   Input.action_release("move_right")

func _finish_club_selection():
	club_completed = true
	active_event = ""
	$UI/EventPanel/VBoxContainer/ClubOption3Button.visible = false
	$UI/EventPanel/VBoxContainer/ClubOption4Button.visible = false
	$UI/EventPanel.visible = false
	update_stats()

func _on_club_option3_button_pressed():
	if active_event == "club_select":
		GameData.selected_club = "Basketball Club"
		_finish_club_selection()

func _on_club_option4_button_pressed():
	if active_event == "club_select":
		GameData.selected_club = "Singing Club"
		_finish_club_selection()

func _setup_ui_styles() -> void:
	# EventPanel — dark green-tinted card
	var ep = StyleBoxFlat.new()
	ep.bg_color = Color(0.06, 0.12, 0.06, 0.92)
	ep.corner_radius_top_left = 12; ep.corner_radius_top_right = 12
	ep.corner_radius_bottom_right = 12; ep.corner_radius_bottom_left = 12
	ep.border_width_left = 1; ep.border_width_top = 1
	ep.border_width_right = 1; ep.border_width_bottom = 1
	ep.border_color = Color(0.25, 0.45, 0.25, 1)
	ep.content_margin_left = 12; ep.content_margin_top = 12
	ep.content_margin_right = 12; ep.content_margin_bottom = 12
	$UI/EventPanel.add_theme_stylebox_override("panel", ep)
	$UI/EventPanel/VBoxContainer/EventTitle.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2, 1.0))
	$UI/EventPanel/VBoxContainer/EventTitle.add_theme_font_size_override("font_size", 18)
	$UI/EventPanel/VBoxContainer/EventLabel.add_theme_color_override("font_color", Color(0.9, 0.95, 0.9, 1))
	$UI/EventPanel/VBoxContainer/EventLabel.add_theme_font_size_override("font_size", 14)

	# Positive action buttons (green)
	for btn in [$UI/EventPanel/VBoxContainer/StartEarlyButton,
				$UI/EventPanel/VBoxContainer/OkButton,
				$UI/EventPanel/VBoxContainer/ClubOption3Button,
				$UI/EventPanel/VBoxContainer/ClubOption4Button]:
		_style_btn(btn, Color(0.08,0.35,0.12,0.9), Color(0.12,0.50,0.18,0.95), Color(0.05,0.22,0.08,0.95))

	# Skip/negative action button (amber)
	_style_btn($UI/EventPanel/VBoxContainer/DoLaterButton,
		Color(0.40,0.22,0.04,0.9), Color(0.55,0.30,0.06,0.95), Color(0.25,0.14,0.02,0.95))

	# Next Week button (teal)
	_style_btn($UI/NextWeekButton,
		Color(0.06,0.28,0.28,0.9), Color(0.08,0.40,0.40,0.95), Color(0.04,0.18,0.18,0.95))

	# Exit button (red)
	_style_btn($UI/ExitButton,
		Color(0.50,0.08,0.08,0.9), Color(0.70,0.12,0.12,0.95), Color(0.35,0.05,0.05,0.95))

	# Stats panel
	var sp = StyleBoxFlat.new()
	sp.bg_color = Color(0.05, 0.08, 0.05, 0.82)
	sp.corner_radius_top_left = 10; sp.corner_radius_top_right = 10
	sp.corner_radius_bottom_right = 10; sp.corner_radius_bottom_left = 10
	sp.content_margin_left = 10; sp.content_margin_top = 10
	sp.content_margin_right = 10; sp.content_margin_bottom = 10
	$UI/StatsPanel.add_theme_stylebox_override("panel", sp)
	$UI/StatsPanel/StatsLabel.add_theme_color_override("font_color", Color(0.9, 0.95, 0.9, 1))
	$UI/StatsPanel/StatsLabel.add_theme_font_size_override("font_size", 15)

	# Week panel
	var wp = StyleBoxFlat.new()
	wp.bg_color = Color(0.05, 0.08, 0.05, 0.82)
	wp.corner_radius_top_left = 10; wp.corner_radius_top_right = 10
	wp.corner_radius_bottom_right = 10; wp.corner_radius_bottom_left = 10
	wp.content_margin_left = 16; wp.content_margin_top = 8
	wp.content_margin_right = 16; wp.content_margin_bottom = 8
	$UI/WeekPanel.add_theme_stylebox_override("panel", wp)
	$UI/WeekPanel/WeekLabel.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2, 1))
	$UI/WeekPanel/WeekLabel.add_theme_font_size_override("font_size", 20)

func _set_event_text(full_text: String) -> void:
	var nl = full_text.find("\n")
	if nl >= 0:
		$UI/EventPanel/VBoxContainer/EventTitle.text = full_text.left(nl)
		$UI/EventPanel/VBoxContainer/EventLabel.text = full_text.substr(nl + 1)
	else:
		$UI/EventPanel/VBoxContainer/EventTitle.text = full_text
		$UI/EventPanel/VBoxContainer/EventLabel.text = ""

func _style_btn(btn: Button, normal: Color, hover: Color, pressed: Color) -> void:
	for pair in [["normal", normal], ["hover", hover], ["pressed", pressed]]:
		var s = StyleBoxFlat.new()
		s.bg_color = pair[1]
		s.corner_radius_top_left = 8; s.corner_radius_top_right = 8
		s.corner_radius_bottom_right = 8; s.corner_radius_bottom_left = 8
		s.content_margin_left = 16; s.content_margin_top = 10
		s.content_margin_right = 16; s.content_margin_bottom = 10
		btn.add_theme_stylebox_override(pair[0], s)
	btn.add_theme_color_override("font_color", Color(1, 1, 1, 1))


func _on_library_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not library_completed:
		setup_library_event() # Replace with function body.


func _on_library_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		active_event = ""
		$UI/EventPanel.visible = false


func _on_kolej_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not kolej_completed:
		setup_kolej_event() # Replace with function body.


func _on_kolej_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		active_event = ""
		$UI/EventPanel.visible = false


func _on_cafeteria_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not cafeteria_completed:
		setup_cafeteria_event() # Replace with function body.


func _on_cafeteria_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		active_event = ""
		$UI/EventPanel.visible = false


func _on_sports_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not sports_completed:
		setup_sports_event() # Replace with function body.


func _on_sports_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		active_event = ""
		$UI/EventPanel.visible = false


func _on_club_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not club_completed:
		setup_club_event() # Replace with function body.


func _on_club_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		active_event = ""
		$UI/EventPanel/VBoxContainer/ClubOption3Button.visible = false
		$UI/EventPanel/VBoxContainer/ClubOption4Button.visible = false
		$UI/EventPanel.visible = false
