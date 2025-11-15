extends Node2D
class_name BaseNPC

# ? This class serves as a base for all NPCs used within the game.
# ? Most of the functions and nodes it has are the same as the Player scene and class
# ? To make a new NPC, just make an instance of this class, and change it's sprite and
# ? the variables on the instanced scene

# ? Animation nodes
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

# ? Interaction nodes for when the player gets in talking/interacting range with NPCs
@onready var interact_up: InteractionArea = $Sprite2D/InteractionAreaUp
@onready var interact_down: InteractionArea = $Sprite2D/InteractionAreaDown
@onready var interact_left: InteractionArea = $Sprite2D/InteractionAreaLeft
@onready var interact_right: InteractionArea = $Sprite2D/InteractionAreaRight

@onready var sprite = $Sprite2D

@export var npc_name: String

@export var interaction_type: String

enum NpcType {NONE, IMPORTANT, LESSON}
# @export var npc_type: NpcType = NpcType.NONE
@onready var important_indicator: Sprite2D = $Indicators/Important

var directions = {
	'up': Vector2.UP,
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT
}

enum NpcState {IDLE, TURNING, WALKING}
enum FacingDirection {UP, DOWN, LEFT, RIGHT}

@export var npc_state: NpcState = NpcState.IDLE
@export var facing_direction: FacingDirection

func _ready() -> void:
	#region # ? Connecting Interaction Areas
	interact_up.interact_type = interaction_type
	interact_down.interact_type = interaction_type
	interact_left.interact_type = interaction_type
	interact_right.interact_type = interaction_type

	interact_up.interact = Callable(self, "_on_interact")
	interact_down.interact = Callable(self, "_on_interact")
	interact_left.interact = Callable(self, "_on_interact")
	interact_right.interact = Callable(self, "_on_interact")
	#endregion

	print(SaveGameManager.get_npc_active(npc_name))

	if SaveGameManager.get_npc_active(npc_name):
		important_indicator.show()
	else:
		important_indicator.hide()	
	SaveGameManager.npc_activity.connect(_on_indicator_update)

	set_direction()

	# set_indicator()

func _on_indicator_update() -> void:
	if SaveGameManager.get_npc_active(npc_name):
		important_indicator.show()
	else:
		important_indicator.hide()

func _on_interact() -> void:
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	PlayerGlobalVars.can_move = false

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	PlayerGlobalVars.can_move = true

func set_direction() -> void:
	match facing_direction:
		FacingDirection.UP:
			anim_tree.set("parameters/Idle/blend_position", Vector2.UP)
		FacingDirection.DOWN:
			anim_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
		FacingDirection.LEFT:
			anim_tree.set("parameters/Idle/blend_position", Vector2.LEFT)
		FacingDirection.RIGHT:
			anim_tree.set("parameters/Idle/blend_position", Vector2.RIGHT)
	anim_state.travel("Idle")

func reset_direction(dir: FacingDirection) -> void:
	match dir:
		FacingDirection.UP:
			anim_tree.set("parameters/Idle/blend_position", Vector2.UP)
			facing_direction = FacingDirection.UP
		FacingDirection.DOWN:
			anim_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
			facing_direction = FacingDirection.DOWN
		FacingDirection.LEFT:
			anim_tree.set("parameters/Idle/blend_position", Vector2.LEFT)
			facing_direction = FacingDirection.LEFT
		FacingDirection.RIGHT:
			anim_tree.set("parameters/Idle/blend_position", Vector2.RIGHT)
			facing_direction = FacingDirection.RIGHT
	anim_state.travel("Idle")

# func set_indicator() -> void:
# 	match npc_type:
# 		NpcType.NONE:
# 			pass
# 		NpcType.IMPORTANT:
# 			important_indicator.show()
# 		NpcType.LESSON:
# 			lesson_indicator.show()

# ? When interacting from above
func _on_area_up_body_entered(_body: Node2D) -> void:
	anim_tree.set("parameters/Idle/blend_position", Vector2.UP)
	anim_state.travel("Idle")

func _on_area_up_body_exited(_body: Node2D) -> void:
	set_direction()

# ? When interacting from below
func _on_area_down_body_entered(_body: Node2D) -> void:
	anim_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
	anim_state.travel("Idle")

func _on_area_down_body_exited(_body: Node2D) -> void:
	set_direction()

# ? When interacting from the left
func _on_area_left_body_entered(_body: Node2D) -> void:
	anim_tree.set("parameters/Idle/blend_position", Vector2.LEFT)
	anim_state.travel("Idle")

func _on_area_left_body_exited(_body: Node2D) -> void:
	set_direction()

# ? When interacting from the right
func _on_area_right_body_entered(_body: Node2D) -> void:
	anim_tree.set("parameters/Idle/blend_position", Vector2.RIGHT)
	anim_state.travel("Idle")

func _on_area_right_body_exited(_body: Node2D) -> void:
	set_direction()


# ? Animation Tree call for Walking Animations
func walk_up() -> void:
	anim_tree.set("parameters/Walk/blend_position", Vector2.UP)
	anim_state.travel("Walk")

func walk_down() -> void:
	anim_tree.set("parameters/Walk/blend_position", Vector2.DOWN)
	anim_state.travel("Walk")

func walk_left() -> void:
	anim_tree.set("parameters/Walk/blend_position", Vector2.LEFT)
	anim_state.travel("Walk")

func walk_right() -> void:
	anim_tree.set("parameters/Walk/blend_position", Vector2.RIGHT)
	anim_state.travel("Walk")

# ? Animation Tree call for Turning Animations
func turn_up() -> void:
	anim_tree.set("parameters/Turn/blend_position", Vector2.UP)
	anim_state.travel("Turn")

func turn_down() -> void:
	anim_tree.set("parameters/Turn/blend_position", Vector2.DOWN)
	anim_state.travel("Turn")

func turn_left() -> void:
	anim_tree.set("parameters/Turn/blend_position", Vector2.LEFT)
	anim_state.travel("Turn")

func turn_right() -> void:
	anim_tree.set("parameters/Turn/blend_position", Vector2.RIGHT)
	anim_state.travel("Turn")
