extends Node2D

@onready var interaction_area: InteractionArea = $Sprite2D/InteractionArea
@onready var sprite: Sprite2D = $Sprite2D

## Name of the function to be called inside the SceneManager autoload class.
@export var scene_manager_function: String

## Name of the scene to be loaded after user interaction.
@export var scene_to_load: String

## X coordinate of the player after loading next scene.
@export var scene_x_coord: float

## Y coordinate of the player after loading next scene.
@export var scene_y_coord: float

## Direction of the player after loading next scene.
@export var starting_dir: PlayerDir

var dir_to_pass: String

enum PlayerDir {
	UP, ## Player's sprite will be facing upwards
	DOWN, ## Player's sprite will be facing downwards
	LEFT, ## Player's sprite will be facing left
	RIGHT ## Player's sprite will be facing right
}

func _ready() -> void:
	interaction_area.interact_type = "Enter"
	interaction_area.action_name = "Enter"
	interaction_area.interact = Callable(self, "_on_interact")
	match starting_dir:
		PlayerDir.UP:
			dir_to_pass = "UP"
		PlayerDir.DOWN:
			dir_to_pass = "DOWN"
		PlayerDir.LEFT:
			dir_to_pass = "LEFT"
		PlayerDir.RIGHT:
			dir_to_pass = "RIGHT"

func _on_interact() -> void:
	SceneManager.call_deferred(scene_manager_function, SceneManager.LEVEL_DICTIONARY[scene_to_load], scene_x_coord, scene_y_coord, dir_to_pass)
