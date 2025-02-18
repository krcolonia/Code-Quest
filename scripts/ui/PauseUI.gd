extends CanvasLayer

@onready var settings_btn = $MarginContainer/VBoxContainer/OptionsPanel/MarginContainer/VBoxContainer/SettingsBtn
@onready var mainmenu_btn = $MarginContainer/VBoxContainer/OptionsPanel/MarginContainer/VBoxContainer/MainMenuBtn
@onready var quit_btn = $MarginContainer/VBoxContainer/OptionsPanel/MarginContainer/VBoxContainer/QuitGameBtn

@onready var settings_ui = $SettingsMenu

func _on_settings_btn_pressed() -> void:
	self.hide()
	settings_ui.show()

func _on_main_menu_btn_pressed() -> void:
	SceneManager.show_loading()
	SaveGameManager.write_save_details()
	SceneManager.return_mainmenu()

func _on_quit_game_btn_pressed() -> void:
	AlertDialog.button1.pressed.connect(self._on_popup_cancel)
	AlertDialog.button2.pressed.connect(self._on_popup_confirm)

	AlertDialog.set_title("Quit Game?")
	AlertDialog.set_message("Are you sure you want to quit the game? Your current progress will be saved as you leave.")

	AlertDialog.set_margin(400, 400)

	AlertDialog.set_button1_name("Cancel")

	AlertDialog.show_button1()
	AlertDialog.show_button2()

	AlertDialog.show()

func _on_popup_cancel() -> void:
	AlertDialog.button1.pressed.disconnect(self._on_popup_cancel)
	AlertDialog.button2.pressed.disconnect(self._on_popup_confirm)
	AlertDialog.close()

func _on_popup_confirm() -> void:
	AlertDialog.button1.pressed.disconnect(self._on_popup_cancel)
	AlertDialog.button2.pressed.disconnect(self._on_popup_confirm)
	
	AlertDialog.close()
	SceneManager.show_loading()
	SaveGameManager.write_save_details()
	await SaveGameManager.finished_saving
	get_tree().quit()

func _on_return_from_settings_button__up() -> void:
	self.show()
	settings_ui.hide()
