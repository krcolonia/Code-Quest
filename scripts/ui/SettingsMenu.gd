extends CanvasLayer

@onready var bgm_slider = $MarginContainer/Panel/MarginContainer/SettingsVBox/MusicHBox/MarginContainer/HSlider
@onready var sfx_slider = $MarginContainer/Panel/MarginContainer/SettingsVBox/SfxHBox/MarginContainer/HSlider

@onready var code_font_size = $MarginContainer/Panel/MarginContainer/SettingsVBox/FontSizeMargin/FontSizeHBox/OptionButton
@onready var guide_check = $MarginContainer/Panel/MarginContainer/SettingsVBox/GuideMargin/GuideHBox/GuideCheck

func _ready() -> void:
	self.hide()
	Settings.BGM_VOLUME_UPDATED.connect(_on_bgm_volume_signal)
	Settings.SFX_VOLUME_UPDATED.connect(_on_sfx_volume_signal)
	Settings.SHOW_PATH_UPDATED.connect(_on_show_guide)
	Settings.CODE_FONT_SIZE_UPDATED.connect(_on_code_font_size_signal)

	Settings.loadData()

func _on_bgm_volume_signal(new_value) -> void:
	bgm_slider.value = new_value

func _on_sfx_volume_signal(new_value) -> void:
	sfx_slider.value = new_value

func _on_show_guide() -> void:
	print("Check UI: " + str(guide_check.is_pressed()))
	print("Loaded Settings: " + str(Settings.show_path))
	if Settings.show_path:
		guide_check.set_pressed_no_signal(true)
	else:
		guide_check.set_pressed_no_signal(false)

func _on_code_font_size_signal(new_value) -> void:
	print(new_value)
	match new_value:
		24.0:
			code_font_size.selected = 0
		32.0:
			code_font_size.selected = 1
		40.0:
			code_font_size.selected = 2

func _on_bgm_slider_value_changed(value:float) -> void:
	Settings.bgm_volume = value

func _on_sfx_slider_value_changed(value:float) -> void:
	Settings.sfx_volume = value

func _on_return_button_up() -> void:
	Settings.saveData()
	self.hide()

func _on_guide_check_pressed() -> void:
	Settings.show_path = guide_check.is_pressed()

func _on_code_font_size_selected(index:int) -> void:
	match index:
		0: # ? Small font size
			Settings.codefont_size = 24.0
		1: # ? Medium font size
			Settings.codefont_size = 32.0
		2: # ? Large font size
			Settings.codefont_size = 40.0
