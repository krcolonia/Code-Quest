extends CharacterBody2D

# ? this whole class holds all player-related functionality.
# ? more will be added [for sure] but as of 5-15-2024 12:51am, movement is all there is here.
# ? ^ more features for movement are added as of 06-10-2024 12:50am.
# ? Players need to turn to a direction before moving in that specified direction.

@onready var sprite := $PlayerSprite

# ? RayCast2D that checks for items with a collision box and area2d for interactions
@onready var ray := $CollisionRaycast

# ? Nodes in charge of sprite animaiton
@onready var anim_tree := $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

const load_sprite = {
	"Male": preload("res://assets/player/Male_MC.png"),
	"Female": preload("res://assets/player/Female_MC.png"),
}

var footstep_sfx := preload("res://assets/sounds/new_footstep.wav")
@onready var audio_stream := $AudioStreamPlayer2D

# ? Grid Size and Speed variables. Used for determining the size at
# ? which a player would move in a grid, and the speed they do so.
@export var grid_size := 16
@export var speed := 4.5
var moving := false

var can_move := true

# ? dictionary variable that holds user inputs
var inputs = {
	'ui_up': Vector2.UP,
	'ui_down': Vector2.DOWN,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT
}

enum PlayerState {IDLE, TURNING, WALKING}
enum FacingDirection {UP, DOWN, LEFT, RIGHT}

@export var player_state: PlayerState = PlayerState.IDLE
@export var facing_direction: FacingDirection

var print_interact = false

func _ready() -> void:
	audio_stream.stream = footstep_sfx
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

	PlayerGlobalVars.get_gender()
	match PlayerGlobalVars.gender:
		"Male":
			sprite.texture = load_sprite.Male
		"Female":
			sprite.texture = load_sprite.Female

func turn_player(dir):
	match dir:
		"UP":
			anim_tree.set("parameters/Turn/blend_position", Vector2.UP)
			facing_direction = FacingDirection.UP
			PlayerGlobalVars.current_direction = PlayerGlobalVars.FacingDirection.UP
			print('turn up')
		"DOWN":
			anim_tree.set("parameters/Turn/blend_position", Vector2.DOWN)
			facing_direction = FacingDirection.DOWN
			PlayerGlobalVars.current_direction = PlayerGlobalVars.FacingDirection.DOWN
			print('turn down')
		"LEFT":
			anim_tree.set("parameters/Turn/blend_position", Vector2.LEFT)
			facing_direction = FacingDirection.LEFT
			PlayerGlobalVars.current_direction = PlayerGlobalVars.FacingDirection.LEFT
			print('turn left')
		"RIGHT":
			anim_tree.set("parameters/Turn/blend_position", Vector2.RIGHT)
			facing_direction = FacingDirection.RIGHT
			PlayerGlobalVars.current_direction = PlayerGlobalVars.FacingDirection.RIGHT
			print('turn right')
	anim_state.travel("Turn")

func _process(_delta):
	if !PlayerGlobalVars.can_move:
		return
	if moving:
		return
	if player_state == PlayerState.TURNING || player_state == PlayerState.WALKING:
		return
	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			anim_tree.set("parameters/Idle/blend_position", inputs[dir])
			anim_tree.set("parameters/Walk/blend_position", inputs[dir])
			anim_tree.set("parameters/Run/blend_position", inputs[dir])
			anim_tree.set("parameters/Turn/blend_position", inputs[dir])
			if need_to_turn(dir):
				player_state = PlayerState.TURNING
				anim_state.travel("Turn")
				return
			move(dir)

# ? Function used for the starting direction that the player is facing
func starting_direction(dir: String) -> void:
	match dir:
		"UP":
			anim_tree.set("parameters/Idle/blend_position", Vector2.UP)
			facing_direction = FacingDirection.UP
			PlayerGlobalVars.current_direction = PlayerGlobalVars.FacingDirection.UP
		"DOWN":
			anim_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
			facing_direction = FacingDirection.DOWN
			PlayerGlobalVars.current_direction = PlayerGlobalVars.FacingDirection.DOWN
		"LEFT":
			anim_tree.set("parameters/Idle/blend_position", Vector2.LEFT)
			facing_direction = FacingDirection.LEFT
			PlayerGlobalVars.current_direction = PlayerGlobalVars.FacingDirection.LEFT
		"RIGHT":
			anim_tree.set("parameters/Idle/blend_position", Vector2.RIGHT)
			facing_direction = FacingDirection.RIGHT
			PlayerGlobalVars.current_direction = PlayerGlobalVars.FacingDirection.RIGHT
	anim_state.travel("Idle")

# ? Function used to check if player needs to turn before moving in a specified direciton
# ? If a player needs to turn before walking, returns true. else, returns false. -krColonia
func need_to_turn(dir):
	reposition_raycast(dir)
	var new_facing_direction
	match inputs[dir]:
		Vector2.UP:
			new_facing_direction = FacingDirection.UP
			PlayerGlobalVars.current_direction = PlayerGlobalVars.FacingDirection.UP
		Vector2.DOWN:
			new_facing_direction = FacingDirection.DOWN
			PlayerGlobalVars.current_direction = PlayerGlobalVars.FacingDirection.DOWN
		Vector2.LEFT:
			new_facing_direction = FacingDirection.LEFT
			PlayerGlobalVars.current_direction = PlayerGlobalVars.FacingDirection.LEFT
		Vector2.RIGHT:
			new_facing_direction = FacingDirection.RIGHT
			PlayerGlobalVars.current_direction = PlayerGlobalVars.FacingDirection.RIGHT

	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true
		
	facing_direction = new_facing_direction
	return false

# ? Used to let this class know that the player object is done turning.
# ? Used primarily during turn animations, nowhere else -krColonia
func finished_turning():
	player_state = PlayerState.IDLE

# ? Function for player movement. Changes the 2D Raycast's target position based on user input
# ? Then, the raycast updates and checks if it's colliding with anything. If not, player can
# ? move. -krColonia
func move(dir):
	reposition_raycast(dir)

	if !ray.is_colliding():
		move_tween(dir)

func reposition_raycast(dir):
	ray.target_position = inputs[dir] * grid_size
	ray.force_raycast_update()

func play_footstep() -> void:
	audio_stream.play()

# ? Function for moving the player and position smoothly using Tween animations. Also changes
# ? the 'moving' boolean variable used in _physics_process function and player_state. -krColonia
func move_tween(dir) -> void:
	var tween = create_tween()
	var state_to_travel

	if Input.is_action_pressed("ui_sprint"):
		state_to_travel = "Run"
		speed = 5.5
	else:
		state_to_travel = "Walk"
		speed = 4.5

	tween.tween_property(self, "position", position + inputs[dir] * grid_size, 1.0 / speed).set_trans(Tween.TRANS_LINEAR)
	anim_state.travel(state_to_travel)
	player_state = PlayerState.WALKING
	moving = true

	await tween.finished
	anim_state.travel("Idle")
	player_state = PlayerState.IDLE
	moving = false

# ? Functions for stopping and continuing movement if an interaction or menu is running
func stop_movement() -> void:
	can_move = false

func continue_movement() -> void:
	can_move = true
