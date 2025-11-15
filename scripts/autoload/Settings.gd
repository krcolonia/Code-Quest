extends Node

# ? Game Settings Variables

signal SFX_VOLUME_UPDATED(new_value)
signal BGM_VOLUME_UPDATED(new_value)
signal SHOW_PATH_UPDATED()
signal CODE_FONT_SIZE_UPDATED(new_value)

enum AudioBusChannels { Master, BGM, SFX }

var codefont_size: float = 24.0:
	set(value):
		if (codefont_size != value):
			codefont_size = value

const CONFIG_FILENAME: String = "user_settings.cfg"

var bgm_volume: float = 1.0:
	set(value):
		if (bgm_volume != value):
			bgm_volume = value
			setBusVolume(AudioBusChannels.BGM, bgm_volume)

var sfx_volume: float = 1.0:
		set(value):
			if (sfx_volume != value):
				sfx_volume = value
				setBusVolume(AudioBusChannels.SFX, sfx_volume)

var show_path: bool = false:
	set(value):
		if(show_path != value):
			show_path = value


func setBusVolume(bus, value):
	AudioServer.set_bus_volume_db(bus,linear_to_db(value))


func loadData():
	var optionsFile = ConfigFile.new()

	var status = optionsFile.load("user://%s" % CONFIG_FILENAME)

	if status == OK:
		sfx_volume = optionsFile.get_value("Options", "sfx_volume")
		bgm_volume = optionsFile.get_value("Options", "bgm_volume")
		show_path = optionsFile.get_value("Options", "show_path")
		codefont_size = optionsFile.get_value("Options", "code_font_size")

		SFX_VOLUME_UPDATED.emit(float(sfx_volume))
		BGM_VOLUME_UPDATED.emit(float(bgm_volume))
		SHOW_PATH_UPDATED.emit()
		CODE_FONT_SIZE_UPDATED.emit(float(codefont_size))

func saveData():
	var optionsFile = ConfigFile.new()

	optionsFile.set_value("Options", "sfx_volume", sfx_volume)
	optionsFile.set_value("Options", "bgm_volume", bgm_volume)
	optionsFile.set_value("Options", "show_path", show_path)
	optionsFile.set_value("Options", "code_font_size", codefont_size)

	optionsFile.save("user://%s" % CONFIG_FILENAME)