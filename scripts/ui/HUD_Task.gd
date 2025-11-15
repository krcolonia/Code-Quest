extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveGameManager.progress_updated.connect(self.update_text)
	update_text()

func update_text() -> void:
	if !SaveGameManager.get_progress('mother', 'intro', 'done'):
		self.text = "Task\nTalk to Mother"
		return
	
	if !SaveGameManager.get_progress('namdal', 'tutorial', 'done'):
		self.text = "Task\nSpeak with Namdal"
		return
	
	if !SaveGameManager.get_progress('namdal', 'id_seal', 'done'):
		self.text = "Task\nCreate your Seal"
		return
	
	if !SaveGameManager.get_progress('seraphius', 'intro', 'done'):
		self.text = "Task\nEnter the Academe"
		return
	
	if !SaveGameManager.get_progress('seraphius', 'lesson_printing', 'done'):
		self.text = "Task\nAttend Seraphius' Class"
		return