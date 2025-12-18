extends CharacterBody2D

@onready var animation_tree: AnimationTree = $Animation/AnimationTree
@onready var move_state_machine : Variant =  animation_tree.get("parameters/MoveStateMachine/playback");
@onready var tool_state_machine: Variant = animation_tree.get("parameters/ToolStateMachine/playback");
@onready var test_layer: TileMapLayer = %TestLayer
@onready var sprite_2d: Sprite2D = $Sprite2D

signal tool_use(tool: Enum.Tool, player_position: Vector2);

var direction: Vector2;
var last_direction: Vector2;
var speed := 50;
var can_move := true;
var current_tool: Enum.Tool = Enum.Tool.AXE;
var current_seed: Enum.Seed;

func _physics_process(_delta: float):
	if(can_move):
		move();
		get_basic_input();
		animate();
	
	if(direction):
		last_direction = direction;

func get_basic_input():

	if(Input.is_action_just_pressed("tool_backward") || Input.is_action_just_pressed("tool_forward")):
		var dir = Input.get_axis("tool_backward", "tool_forward");
		current_tool = posmod((current_tool + int(dir)), Enum.Tool.size()) as Enum.Tool;

	if(Input.is_action_just_pressed("seed_forward")):
		current_seed = (current_seed + 1) % Enum.Seed.size() as Enum.Seed;

	if(Input.is_action_just_pressed("action")):
		tool_state_machine.travel(Data.TOOL_STATE_ANIMATIONS[current_tool]);
		animation_tree.set("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);

func move():
	direction = Input.get_vector("left", "right", "up", "down");
	velocity = direction * speed;
	move_and_slide();

func animate():
	if(direction):
		move_state_machine.travel("Walk");
		animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", direction.round());
		animation_tree.set("parameters/MoveStateMachine/Walk/blend_position", direction.round());

		for tool in Data.TOOL_STATE_ANIMATIONS.values():
			animation_tree.set("parameters/ToolStateMachine/" + tool + "/blend_position", direction.round());

	else:
		move_state_machine.travel("Idle");
 
func tool_use_emit():
	tool_use.emit(current_tool, position + (exclude_verticals(last_direction) *12));

func _on_animation_tree_animation_started(_anim_name: StringName) -> void:
	can_move = false

func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	can_move = true

# convert 9 diections to only 4, excluding verticals
func exclude_verticals(dir : Vector2):
	
	if(round(dir.x)== -1):
		return Vector2(-1, 0);
	if(round(dir.x) == 1):
		return Vector2(1, 0);

	return dir;
