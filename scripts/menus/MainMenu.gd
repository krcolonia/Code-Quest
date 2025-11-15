extends CanvasLayer

@onready var start_btn = $InputCanvasLayer/MenuBtns/StartBtn

@onready var inputcanvas = $InputCanvasLayer
@onready var settingscanvas = $SettingsMenu
@onready var profilecanvas = $ProfileMenu
@onready var leaderboardcanvas = $Leaderboard
@onready var achievementcanvas = $AchievementMenu

@onready var bot_achieveBtn = $InputCanvasLayer/BottomMenuBtns/achieveBtn
@onready var bot_leaderboardBtn = $InputCanvasLayer/BottomMenuBtns/leaderboardBtn
@onready var bot_settingsBtn = $InputCanvasLayer/BottomMenuBtns/settingsBtn

@onready var achieve_close = $AchievementMenu/CloseButton

@onready var profile_logoutBtn = $ProfileMenu/MarginContainer/Panel/MarginContainer/VBoxContainer/LogoutBtn

var user_info: Dictionary
# var CompilerPlugin

func _ready() -> void:
	# ? The commented lines below is just an android plugin that I'm unsure of using just yet
	# ? If I have the extra time to implement it, why not? But for now, I'll stick to basics. -krColonia
	# if Engine.has_singleton("CodeQuestCompilerPlugin"):
	# 	CompilerPlugin = Engine.get_singleton("CodeQuestCompilerPlugin")
	# 	print(CompilerPlugin.InitChaquoPy())
	
	bot_achieveBtn.button_up.connect(_on_achievement_button_up)
	bot_leaderboardBtn.button_up.connect(_on_leaderboard_button_up)
	bot_settingsBtn.button_up.connect(_on_setting_btn_up)

	achieve_close.button_up.connect(_on_close_achievement_button_up)
	profile_logoutBtn.button_up.connect(_on_logout_button_up)

	AlertDialog.button1.pressed.connect(self._on_popup_close)
	AlertDialog.button2.pressed.connect(self._on_popup_confirm)
	
	if Firebase.user_exists():
		user_info = FileAccess.open(Firebase.USER_DATA_PATH, FileAccess.READ).get_var()
	
	if SaveGameManager.get_prologue_done():
		start_btn.text = "START"
	else: 
		start_btn.text = "CONTINUE"

func _on_start_btn_button_up() -> void:
	if SaveGameManager.get_prologue_done():
		SceneManager.start_new_game()
	else: 
		SceneManager.continue_game()

func _on_setting_btn_up() -> void:
	inputcanvas.hide()
	settingscanvas.show()

func _on_close_settings_button_up() -> void:
	inputcanvas.show()

func _on_profile_btn_button_up() -> void:
	profilecanvas._reload_profile()
	inputcanvas.hide()
	profilecanvas.show()

func _on_achievement_button_up() -> void:
	inputcanvas.hide()
	achievementcanvas.show()

func _on_close_achievement_button_up() -> void:
	inputcanvas.show()
	achievementcanvas.hide()

func _on_leaderboard_button_up() -> void:
	inputcanvas.hide()
	leaderboardcanvas._reload_leaderboards()
	leaderboardcanvas.show()

func _on_close_leaderboard_button_up() -> void:
	inputcanvas.show()
	leaderboardcanvas.hide()

func _on_close_profile_button_up() -> void:
	inputcanvas.show()

func _on_exit_btn_button_up() -> void:
	get_tree().quit()

func _on_logout_button_up() -> void:
	AlertDialog.set_title("Logging Out of Account")
	AlertDialog.set_message("Are you sure you'd like to log-out of your account? You will be redirected back to the Title Screen")

	AlertDialog.set_margin(420, 420)

	AlertDialog.set_button1_name('Cancel')

	AlertDialog.show_button1()
	AlertDialog.show_button2()

	AlertDialog.show()

func _on_popup_close() -> void:
	AlertDialog.close()

func _on_popup_confirm() -> void:
	AlertDialog.close()
	AlertDialog.button1.pressed.disconnect(self._on_popup_close)
	AlertDialog.button2.pressed.disconnect(self._on_popup_confirm)

	if FileAccess.file_exists("user://save_data.save"):
		DirAccess.remove_absolute("user://save_data.save")

	if FileAccess.file_exists("user://user_info.save"):
		DirAccess.remove_absolute("user://user_info.save")

	SceneManager.change_menu(SceneManager.MENU_DICTIONARY["TITLE_SCREEN"])
