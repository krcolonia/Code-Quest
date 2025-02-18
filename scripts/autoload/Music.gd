extends AudioStreamPlayer

var tracks: Dictionary = {
	"MENU": preload("res://assets/music/MainMenu_BGM.mp3"),
	"HOUSE": preload("res://assets/music/House_BGM.mp3"),
	"TOWN": preload("res://assets/music/Town_BGM.mp3"),
	"TAVERN": preload("res://assets/music/Tavern_BGM.mp3"),
	"ACADEME": preload("res://assets/music/Academe_BGM.mp3"),
	"STUDY": preload("res://assets/music/StudyHall_BGM.mp3"),
	"FORGE": preload("res://assets/music/Forge_BGM.mp3"),
	"LIBRARY": preload("res://assets/music/Library_BGM.mp3"),
}

var fade_duration = 2.0

var tween

func fade_in() -> void:
	tween = create_tween()
	self.volume_db = -80
	self.play()
	tween.tween_property(self, "volume_db", 0, fade_duration)

func fade_out() -> void:
	tween = create_tween()
	tween.tween_property(self, "volume_db", -80, fade_duration)