extends Node2D

@onready var player = SceneManager.player
@onready var label = $Label

@onready var dialogue_indicator: Sprite2D = $NpcIndicator/Dialogue
@onready var item_indicator: Sprite2D = $NpcIndicator/Item

const base_text = "Interact to "

var active_areas = []
var can_interact = true
var is_facing = true

var type: String = ""
var pos: String = ""

func register_area(area: InteractionArea, interact_type: String):
	get_tree().call_group("ui", "enable_interact_button")
	active_areas.push_back(area)
	type = interact_type

func unregister_area(area: InteractionArea):
	get_tree().call_group("ui", "disable_interact_button")
	var index = active_areas.find(area)
	if index != -1:
			active_areas.remove_at(index)

func indicator_setter(indicator: Sprite2D, offset: int) -> void:
	indicator.show()
	indicator.global_position = active_areas[0].global_position
	indicator.global_position.y -= offset
	pass

func _process(_delta):
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		match type:
			"dialogue":
				indicator_setter(dialogue_indicator, 40)
			"item":
				indicator_setter(item_indicator, 28)
			_:
				label.text = base_text + active_areas[0].action_name
				label.global_position = active_areas[0].global_position
				label.global_position.y -= 36
				label.global_position.x -= label.size.x / 2
				label.show()
	else:
		label.hide()
		dialogue_indicator.hide()
		item_indicator.hide()

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event):
	if event.is_action_pressed("ui_interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			get_tree().call_group("player", "stop_movement")
			label.hide()

			await active_areas[0].interact.call()
			can_interact = true
			get_tree().call_group("player", "continue_movement")
