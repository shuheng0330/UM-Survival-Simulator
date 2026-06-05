extends Node

const MUSIC_PATH = "res://assets/audio/music/"
const SFX_PATH  = "res://assets/audio/sfx/"

var _music: AudioStreamPlayer
var _sfx: AudioStreamPlayer

func _ready() -> void:
	_music = AudioStreamPlayer.new()
	_music.volume_db = -10.0
	add_child(_music)

	_sfx = AudioStreamPlayer.new()
	add_child(_sfx)

	play_music()

func play_music() -> void:
	if _music.playing:
		return
	var path = MUSIC_PATH + "background.ogg"
	if not ResourceLoader.exists(path):
		return
	var stream = load(path)
	if stream is AudioStreamOggVorbis:
		stream.loop = true
	_music.stream = stream
	_music.play()

func stop_music() -> void:
	_music.stop()

func play_sfx(name: String) -> void:
	var path = SFX_PATH + name + ".wav"
	if not ResourceLoader.exists(path):
		return
	_sfx.stream = load(path)
	_sfx.play()
