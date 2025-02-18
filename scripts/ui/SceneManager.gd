extends CanvasLayer

# ? Main Menu
const MENU_DICTIONARY: Dictionary = {
	"TITLE_SCREEN": preload("res://scenes/menus/TitleScreen.tscn"),
	"CHECK_SCREEN": preload("res://scenes/menus/CheckLogScreen.tscn"),
	"LOGIN_SCREEN": preload("res://scenes/account_management/LoginScreen.tscn"),
	"REGISTER_SCREEN": preload("res://scenes/account_management/RegisterScreen.tscn"),
	"MAIN_MENU": preload("res://scenes/menus/MainMenu.tscn"),
}

# ? Level 1 Scenes
const LEVEL_DICTIONARY: Dictionary = {
	"LEVEL1_INTERIOR": preload("res://scenes/levels/level1/Lvl1_Interiors.tscn"),
	"LEVEL1_EXTERIOR": preload("res://scenes/levels/level1/Lvl1_Exterior.tscn"),
	"LEVEL2_INTERIOR": preload("res://scenes/levels/level2/Lvl2_Interiors.tscn"),
}

@onready var color_rect =  $ColorRect
@onready var loading_node = $CenterContainer/Control
@onready var loading_anim = $CenterContainer/Control/AnimatedSprite2D
@onready var anim = $AnimationPlayer

var loaded_stage
var player

signal player_stage_changed

func _ready() -> void:
	color_rect.hide()
	loading_anim.play("default")

func show_loading() -> void:
	self.layer = 10
	color_rect.show()
	anim.play("loading")

func reset_animplayer() -> void:
	self.layer = 0
	color_rect.hide()
	anim.play("RESET")

func reset_ui_inputs() -> void:
	Input.action_release("ui_up")
	Input.action_release("ui_down")
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	Input.action_release("ui_sprint")

func start_animation() -> void:
	self.layer = 10
	color_rect.show()
	anim.play("start_transition")

func end_animation() -> void:
	anim.play('end_transition')
	await anim.animation_finished
	print('end_transition-ended')
	self.layer = 0
	color_rect.hide()

func continue_game() -> void:
	var stage_index = int(get_tree().get_root().get_child_count()) - 1

	var save_data: Dictionary = SaveGameManager.data

	PlayerGlobalVars.can_move = false

	Music.fade_out()

	self.layer = 10
	color_rect.show()
	anim.play("start_transition")
	await anim.animation_finished
	print('start_transition ended')

	loaded_stage = LEVEL_DICTIONARY[save_data.map_name].instantiate()
	get_tree().get_root().get_child(stage_index).free()
	get_tree().get_root().add_child(loaded_stage)

	player = loaded_stage.get_node("Game Objects").find_child("Player") # HACK: This is a slower method of finding the Player node in a game level's scene tree.
	get_tree().call_group("player", "starting_direction", save_data.global_position.dir)
	player.position = Vector2(save_data.global_position.x,save_data.global_position.y)

	await get_tree().create_timer(1.0).timeout
	anim.play('end_transition')
	await anim.animation_finished
	print('end_transition-ended')
	self.layer = 0
	color_rect.hide()

	PlayerGlobalVars.can_move = true

func start_new_game() -> void:
	var stage_index = int(get_tree().get_root().get_child_count()) - 1

	var save_data: Dictionary = SaveGameManager.data
	print(save_data)

	PlayerGlobalVars.can_move = false

	Music.fade_out()

	self.layer = 10
	color_rect.show()
	anim.play("start_samelevel_trns_blk")
	await anim.animation_finished

	loaded_stage = LEVEL_DICTIONARY[save_data.map_name].instantiate()
	get_tree().get_root().get_child(stage_index).free()
	get_tree().get_root().add_child(loaded_stage)

	player = loaded_stage.get_node("Game Objects").find_child("Player") # HACK: This is a slower method of finding the Player node in a game level's scene tree.
	get_tree().call_group("player", "starting_direction", save_data.global_position.dir)
	player.position = Vector2(save_data.global_position.x,save_data.global_position.y)

	Dialogic.start('Prologue')
	
	await Dialogic.timeline_ended

	anim.play("end_samelevel_trns_blk")
	await anim.animation_finished
	self.layer = 0
	color_rect.hide()

	SaveGameManager.set_progress("mother", "intro", "active", true)
	SaveGameManager.set_npc_active("mother", true)
	SaveGameManager.set_prologue_done()
	PlayerGlobalVars.can_move = true

	SaveGameManager.write_save_details()
	await SaveGameManager.finished_saving

func change_stage(stage_path, x, y, starting_dir) -> void:
	var stage_index = int(get_tree().get_root().get_child_count()) - 1
	
	PlayerGlobalVars.can_move = false

	Music.fade_out()

	self.layer = 10
	color_rect.show()
	anim.play("start_transition")
	await anim.animation_finished
	print('start_transition ended')

	loaded_stage = stage_path.instantiate()
	get_tree().get_root().get_child(stage_index).free()
	get_tree().get_root().add_child(loaded_stage)

	player = loaded_stage.get_node("Game Objects").find_child("Player") # HACK: This is a slower method of finding the Player node in a game level's scene tree.
	get_tree().call_group("player", "starting_direction", starting_dir)
	player.position = Vector2(x,y)

	SaveGameManager.write_save_details()
	await SaveGameManager.finished_saving

	await get_tree().create_timer(1.0).timeout
	anim.play('end_transition')
	await anim.animation_finished
	print('end_transition-ended')
	self.layer = 0
	color_rect.hide()

	reset_ui_inputs()
	PlayerGlobalVars.can_move = true

	player_stage_changed.emit()

func change_location(x, y, starting_dir) -> void:
	var stage_index = int(get_tree().get_root().get_child_count()) - 1

	PlayerGlobalVars.can_move = false

	self.layer = 10
	color_rect.show()
	anim.play("start_samelevel_trns_blk")
	await anim.animation_finished
	print('start_transition ended')

	player = get_tree().get_root().get_child(stage_index).get_node("Game Objects").find_child("Player") # HACK: This is a slower method of finding the Player node in a game level's scene tree.
	get_tree().call_group("player", "starting_direction", starting_dir)
	player.position = Vector2(x,y)

	SaveGameManager.write_save_details()
	await SaveGameManager.finished_saving

	await get_tree().create_timer(0.5).timeout
	anim.play("end_samelevel_trns_blk")
	await anim.animation_finished
	print('end_transition-ended')
	self.layer = 0
	color_rect.hide()

	reset_ui_inputs()
	PlayerGlobalVars.can_move = true

	player_stage_changed.emit()

func return_mainmenu() -> void:
	var stage_index = int(get_tree().get_root().get_child_count()) - 1

	Music.fade_out()

	await SaveGameManager.finished_saving
	SceneManager.reset_animplayer()

	self.layer = 10
	color_rect.show()
	anim.play("start_transition")
	await anim.animation_finished
	print('start_transition ended')

	var stage = MENU_DICTIONARY["MAIN_MENU"].instantiate()
	get_tree().get_root().get_child(stage_index).free()
	get_tree().get_root().add_child(stage)

	await get_tree().create_timer(1.0).timeout
	anim.play('end_transition')
	await anim.animation_finished
	print('end_transition-ended')
	self.layer = 0
	color_rect.hide()

	Music.set_stream(Music.tracks.MENU)
	Music.fade_in()

func change_menu(menu_path) -> void:
	var menu_index = int(get_tree().get_root().get_child_count()) - 1

	var menu = menu_path.instantiate()
	get_tree().get_root().get_child(menu_index).queue_free()
	get_tree().get_root().add_child(menu)
