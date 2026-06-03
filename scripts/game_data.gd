extends Node


## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
var player_name = ""
var age = 21
var major = ""
var kolej = ""
var selected_club: String = ""

var final_gpa: float = 0.0
var final_stress: int = 0
var final_energy: int = 0
var final_money: int = 0
var final_social: int = 0
var ending_type: String = ""
var exam_score: int = 0

var is_loading_save: bool = false

var save_gpa: float = 3.0
var save_stress: int = 20
var save_energy: int = 80
var save_money: int = 100
var save_social: int = 50
var save_week: int = 1
var save_faculty_completed: bool = false
var save_library_completed: bool = false
var save_kolej_completed: bool = false
var save_cafeteria_completed: bool = false
var save_sports_completed: bool = false
var save_club_completed: bool = false
var save_sports_visit_count: int = 0

func has_save_file() -> bool:
	return FileAccess.file_exists("user://savegame.cfg")

func save_game():
	var cfg = ConfigFile.new()
	cfg.set_value("player", "name", player_name)
	cfg.set_value("player", "age", age)
	cfg.set_value("player", "major", major)
	cfg.set_value("player", "kolej", kolej)
	cfg.set_value("player", "selected_club", selected_club)
	cfg.set_value("game", "gpa", save_gpa)
	cfg.set_value("game", "stress", save_stress)
	cfg.set_value("game", "energy", save_energy)
	cfg.set_value("game", "money", save_money)
	cfg.set_value("game", "social", save_social)
	cfg.set_value("game", "week", save_week)
	cfg.set_value("game", "faculty_completed", save_faculty_completed)
	cfg.set_value("game", "library_completed", save_library_completed)
	cfg.set_value("game", "kolej_completed", save_kolej_completed)
	cfg.set_value("game", "cafeteria_completed", save_cafeteria_completed)
	cfg.set_value("game", "sports_completed", save_sports_completed)
	cfg.set_value("game", "club_completed", save_club_completed)
	cfg.set_value("game", "sports_visit_count", save_sports_visit_count)
	cfg.save("user://savegame.cfg")

func load_game():
	var cfg = ConfigFile.new()
	if cfg.load("user://savegame.cfg") != OK:
		return
	player_name = cfg.get_value("player", "name", "")
	age = cfg.get_value("player", "age", 21)
	major = cfg.get_value("player", "major", "")
	kolej = cfg.get_value("player", "kolej", "")
	selected_club = cfg.get_value("player", "selected_club", "")
	save_gpa = cfg.get_value("game", "gpa", 3.0)
	save_stress = cfg.get_value("game", "stress", 20)
	save_energy = cfg.get_value("game", "energy", 80)
	save_money = cfg.get_value("game", "money", 100)
	save_social = cfg.get_value("game", "social", 50)
	save_week = cfg.get_value("game", "week", 1)
	save_faculty_completed = cfg.get_value("game", "faculty_completed", false)
	save_library_completed = cfg.get_value("game", "library_completed", false)
	save_kolej_completed = cfg.get_value("game", "kolej_completed", false)
	save_cafeteria_completed = cfg.get_value("game", "cafeteria_completed", false)
	save_sports_completed = cfg.get_value("game", "sports_completed", false)
	save_club_completed = cfg.get_value("game", "club_completed", false)
	save_sports_visit_count = cfg.get_value("game", "sports_visit_count", 0)
	is_loading_save = true

func delete_save():
	if has_save_file():
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://savegame.cfg"))
